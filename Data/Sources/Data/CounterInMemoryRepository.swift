import Domain

// 🚨 Mark this as public, otherwise Presentation won't see it
public class CounterInMemoryRepository: CounterRepository {
    // 💡 Mutable property
    private var count: Int
    // 💡 Immutable property
    private let enableResetFailure: Bool
    
    // default value 0
    public init(initialCount: Int = 0, enableResetFailure: Bool = false) {
        self.count = initialCount
        self.enableResetFailure = enableResetFailure
    }
    
    private func debugDelay(millis: Int = 250) async {
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for: .milliseconds(millis))
        }
    }
    
    public func getCounterValue() async -> Int {
        await debugDelay(millis: 1000)
        return count
    }
    
    public func increment() async -> Int {
        await debugDelay()
        count += 1
        return count
    }
    
    public func decrement() async -> Int {
        await debugDelay()
        count -= 1
        return count
    }
    
    public func reset() async throws {
        await debugDelay()
        
        // Simulate error 50% of calls when enabled
        if enableResetFailure && Int.random(in: 1...2) == 1 {
            throw CounterRepositoryError.resetNotAllowed
        }
        
        count = 0
    }
}
