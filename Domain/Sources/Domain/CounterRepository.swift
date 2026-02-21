import Foundation

// 🚨 Mark this as public, otherwise Data and Presentation won't see it
public protocol CounterRepository {
    func getCounterValue() async -> Int
    func increment() async -> Int
    func decrement() async -> Int
    func reset() async throws
}

public enum CounterRepositoryError: Error {
    case resetNotAllowed
}
