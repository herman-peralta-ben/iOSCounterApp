func recordStates<S>(
    initialState: S,
    setup: @escaping (@escaping (S) -> Void) async -> Void,
    action: () async -> Void
) async -> [S] {
    var history: [S] = [initialState]
    
    let stream = AsyncStream<S> { continuation in
        Task {
            await setup { newState in
                continuation.yield(newState)
            }
        }
    }
    
    let collectorTask = Task {
        for await s in stream {
            history.append(s)
        }
        return history
    }
    
    await action()
    
    await Task.yield()
    try? await Task.sleep(for: .milliseconds(20))
    
    collectorTask.cancel()
    
    return await collectorTask.value
}
