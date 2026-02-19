import Domain

// 🚨 Mark this as public, otherwise Presentation won't see it
public class CounterInMemoryRepository: CounterRepository {
    private var count: Int
    
    // default value 0
    public init(initialCount: Int = 0) {
        self.count = initialCount
    }
    
    public func getCounterValue() async -> Int {
        return count
    }
    
    public func increment() async -> Int {
        count += 1
        return count
    }
    
    public func decrement() async -> Int {
        count -= 1
        return count
    }
    
    public func reset() async {
        count = 0
    }
}
