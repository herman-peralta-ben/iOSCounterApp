import Foundation
import Observation
import Domain

@Observable
@MainActor
// @MainActor: Makes the ViewModel Tasks {} to be executed on the Main Thread, not explicitly Thread safe.
// Since ViewModel is @Observable, any change to its properties triggers a UI refresh.
final class CounterViewModel {
    
    // 🚨 Implementing Unidirectional Data Flow
    private(set) var state: CounterState = .idle {
        didSet { onStateChange?(state) }
    }

    /// INTERNAL: Only for testing purposes. Used by ``recordStates(initialState:setup:action:)``  to capture emissions.
    var onStateChange: ((CounterState) -> Void)?
    
    private let repository: CounterRepository
    
    public init(repository: CounterRepository) {
        self.repository = repository
    }
    
    // 🚨 ViewModel methods don't need to be async (we can use Task {} here instead of the UI).
    //    - Since this ViewModel is annotated with @MainActor, all the tasks will be executed in the MainActor thread, i.e. the UI.
    //    - On Android we use viewModelScope which is bound to the ViewModel lifecycle, so when
    //    the ViewModel dies, the coroutine is cancelled.
    //    - On iOS we need to handle this carefully
    private func performAction(_ action: @escaping () async -> Int) {
        Task {
            state = .loading
            let newValue = await action()
            state = .success(newValue)
        }
    }
    
    func start() {
        performAction { await self.repository.getCounterValue() }
    }
    
    func increment() {
        performAction { await self.repository.increment() }
    }
    
    func decrement() {
        performAction { await self.repository.decrement() }
    }
    
    func reset() {
        Task {
            self.state = .loading
            
            do {
                try await repository.reset()

                let value = await repository.getCounterValue()
                self.state = .success(value)
            } catch {
                self.state = .error(
                    ErrorData(
                        title: "Couldn't reset",
                        message: error.localizedDescription,
                    )
                )
            }
        }
    }
}
