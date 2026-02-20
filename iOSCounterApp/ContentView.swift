import SwiftUI
import Domain
import Data

// 💡 struct:
// Flutter Widget = Swift Struct = Android @Composable:
// All are lightweight descriptions of the UI at a specific point in time.
// In iOS, structs are "Value Types" (allocated on the Stack), making them
// extremely fast to create and destroy compared to Heap-allocated Classes
// (Garbage Collector).
//
// 💡 Persistence / State Management:
// The Blueprint (Widget/Composable/View) is what you see (ephemeral),
// but the Backend (Element Tree/Slot Table/Attribute Graph) is what remembers
// the data (persistent).
//
// In all three, the "Blueprint" is cheap and disposable,
// while the Framework keeps the actual data safe in these internal structures.
struct ContentView: View {
    
    // 💡 @State: Property Wrapper for local state.
    // Similar to Compose's 'mutableStateOf'/'remember', or Flutter's 'setState()'.
    // 1. Mutation: You run counter += 1.
    // 2. Notification: The @State property wrapper notifies the system that its value just changed.
    // 3. Invalidation: SwiftUI identifies every View that "reads" that specific counter variable.
    // 4. Re-evaluating the Body: SwiftUI calls the var body: some View property again.
    // 5. Diffing: SwiftUI compares the new body with the old body (this is very fast, just like the Virtual DOM or Flutter's Element Tree).
    // 6. Patching: It only updates the specific parts of the actual screen that changed (e.g., the Text showing the number).
    @State private var viewModel: CounterViewModel
    
    init(viewModel: CounterViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    // 💡 'body': Computed property that defines the View hierarchy.
    // Equivalent to the build() method in Flutter or a @Composable function.
    var body: some View {

        VStack(spacing: 20) {
            Text("iOS Counter App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            VStack(spacing: 20) {
                Group {
                    switch viewModel.state {
                    case .idle, .loading, .error: // 💡OR
                        ProgressView()
                    case .success(let count):
                        Text("\(count)")
                            .font(.system(size: 80, weight: .bold))
                            .padding()
                        // region 💡 correct way to add an animation
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity).animation(.spring()),
                                removal: .opacity.animation(.easeInOut)
                            ))
                            .id(count) // 🚨 Important, we ask to apply animation when count changes
                        // endregion 💡 correct way to add an animation
                        HStack(spacing: 20) {
                            CounterButton(icon: "minus", color: .red, action: viewModel.decrement)
                            CounterButton(icon: "plus", color: .green, action: viewModel.increment)
                        }
                        
                        Button(action: viewModel.reset) {
                            Text("Reset")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                }
            }.task {
                // 💡 Similar to Flutter's BlocConsumer, will redraw the caller UI once this
                // task completes. It's a wrapper for Task {...}.
                viewModel.start()
            }
        }
        .padding()
        .alert(
            item: Binding(
                get: {
                    // 💡 Only when the state is error, return the data to make the dialog appear
                    if case .error(let data) = viewModel.state { return data }
                    return nil
                },
                set: { _ in
                    // This is called when the user closes the dialog
                    // But we handle it on the buttons
                }
            )
        ) { errorData in
            Alert(
                title: Text(errorData.title),
                message: Text(errorData.message),
                primaryButton: .default(Text("Retry")) {
                    viewModel.reset()
                },
                secondaryButton: .default(Text("OK")) {
                    viewModel.start() // fallback to last value
                }
            )
        }
    }
}

// MARK: - Previews

#Preview("Default counter init") {
    ContentView(viewModel: CounterViewModel(repository: CounterInMemoryRepository()))
}

#Preview("Default counter init with reset error") {
    ContentView(viewModel: CounterViewModel(repository: CounterInMemoryRepository(enableResetFailure: true)))
}

#Preview("Custom small counter init") {
    ContentView(viewModel: CounterViewModel(repository: CounterInMemoryRepository(initialCount: 42)))
}

#Preview("Custom large counter init ") {
    ContentView(viewModel: CounterViewModel(repository: CounterInMemoryRepository(initialCount: 9999999)))
}
