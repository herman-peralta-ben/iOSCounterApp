import Foundation
import Observation
import Domain

@Observable
@MainActor
// @MainActor: Makes the ViewModel thread safe.
// Since ViewModel is @Observable, any change to its properties triggers a UI refresh.
final class CounterViewModel {
    
    public private(set) var counter: Int?
    public private(set) var activeError: ErrorData?
    
    private let repository: CounterRepository
    
    public init(repository: CounterRepository) {
        self.repository = repository
    }
    
    // 🚨 ViewModel methods don't need to be async (we can use Task {} here instead of the UI).
    //    - Since this ViewModel is annotated with @MainActor, all the tasks will be executed in the MainActor thread, i.e. the UI.
    //    - On Android we use viewModelScope which is bound to the ViewModel lifecycle, so when
    //    the ViewModel dies, the coroutine is cancelled.
    //    - On iOS we need to handle this carefully
    func start() {
        Task {
            self.counter = await repository.getCounterValue()
        }
    }
    
    func increment() {
        Task {
            self.counter = nil
            
            self.counter = await repository.increment()
        }
    }
    
    func decrement() {
        Task {
            self.counter = nil
            
            self.counter = await repository.decrement()
        }
    }
    
    func reset() {
        Task {
            self.counter = nil
            
            do {
                try await repository.reset()
                self.counter = await repository.getCounterValue()
            } catch {
                self.activeError = ErrorData(
                    title: "Couldn't reset",
                    message: error.localizedDescription
                )
                // 💡 Optional, recover last value
                self.counter = await repository.getCounterValue()
            }
        }
    }
    
    func resetActiveError() {
        activeError = nil
    }
}
