import Testing
import Foundation
@testable import Data

struct CounterInMemoryRepositoryTests {

    @Test("Initial value should be zero")
    func initialState() async {
        // Arrange
        let sut = CounterInMemoryRepository()

        // Act
        let value = await sut.getCounterValue()

        // Assert
        #expect(value == 0)
    }

    @Test("Incrementing increases the value by one")
    func increment() async {
        // Arrange
        let sut = CounterInMemoryRepository()

        // Act
        let newValue = await sut.increment()

        // Assert
        #expect(newValue == 1)
        let storedValue = await sut.getCounterValue()
        #expect(storedValue == 1)
    }

    @Test("Decrementing decreases the value by one")
    func decrement() async {
        // Arrange
        let sut = CounterInMemoryRepository()

        // Act
        let newValue = await sut.decrement()

        // Assert
        #expect(newValue == -1)
        let storedValue = await sut.getCounterValue()
        #expect(storedValue == -1)
    }

    @Test("Reset clears the counter to zero")
    func reset() async throws {
        // Arrange
        let sut = CounterInMemoryRepository()

        // Act
        _ = await sut.increment()
        try await sut.reset()

        // Assert
        let value = await sut.getCounterValue()
        #expect(value == 0)
    }

    // 🚨 This is possible because CounterInMemoryRepository is an `actor`.
    // 💡 Atomicity: In Android, this is equivalent to testing an AtomicInteger with 200 Threads.
    // 💡 TaskGroup: Similar to Dart's `Future.wait()`, Kotlin's `coroutineScope`, or Java's `CompletableFuture.allOf()`.
    //    However, Swift's Structured Concurrency (like Kotlin's `coroutineScope`) automatically
    //    cleans up all child tasks if one fails.
    @Test("Handle mixed concurrent operations correctly")
    func mixedConcurrentOperations() async {
        // Arrange
        let sut = CounterInMemoryRepository()

        // Act
        // This scope suspends until all 200 child tasks have finished
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<200 {
                group.addTask {
                    if i % 2 == 0 {
                        _ = await sut.increment()
                    } else {
                        _ = await sut.decrement()
                    }
                }
            }
        }
        let finalValue = await sut.getCounterValue()

        // Assert
        #expect(finalValue == 0)
    }
}
