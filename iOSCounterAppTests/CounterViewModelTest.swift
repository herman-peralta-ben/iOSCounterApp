import Testing
import Foundation
import Domain
@testable import iOSCounterApp

private class MockCounterRepository: CounterRepository {
    public var valueToReturn = 0
    public var shouldThrowError = false
    
    init(valueToReturn: Int = 0, shouldThrowError: Bool = false) {
        self.valueToReturn = valueToReturn
        self.shouldThrowError = shouldThrowError
    }
    
    func getCounterValue() async -> Int { valueToReturn }
    func increment() async -> Int { valueToReturn }
    func decrement() async -> Int { valueToReturn }
    func reset() async throws {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
    }
}

struct CounterViewModelTests {
    
    @Test("Initial state is success with value from repository")
    func initialState() async throws {
        // Arrange
        let mockRepo = MockCounterRepository(valueToReturn: 42)
        let sut = await CounterViewModel(repository: mockRepo)
        
        // Act
        await sut.start()
        
        // Assert
        // 🚨 Flaky test, wait a bit, note that this can be replaced with `recordStates` util.
        try await Task.sleep(for: .milliseconds(50))
        
        let currentState = await sut.state
        #expect(currentState == .success(42))
    }
    
    @Test("Increment updates state to loading then success")
    func incrementFlow() async throws {
        // Arrange
        let mockRepo = MockCounterRepository(valueToReturn: 0)
        let sut = await CounterViewModel(repository: mockRepo)
        mockRepo.valueToReturn = 42
        
        // Act recording examples
        let states = await recordStates(
            initialState: await sut.state,
            setup: { hook in
                await MainActor.run { sut.onStateChange = hook }
            },
            action: { await sut.increment() }
        )
       
        // Assert
        #expect(states.count >= 3)
        #expect(states.contains(.loading))
        #expect(states.last == .success(42))
    }
}
