import SwiftUI

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
    @State private var counter: Int = 0
    
    // 💡 'body': Computed property that defines the View hierarchy.
    // Equivalent to the build() method in Flutter or a @Composable function.
    var body: some View {
        VStack(spacing: 20) {
            Text("iOS Counter App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("\(counter)")
                .font(.system(size: 80, weight: .bold))
                .padding()
            
            HStack(spacing: 20) {
                CounterButton(icon: "minus", color: .red, action: decrementCounter)
                CounterButton(icon: "plus", color: .green, action: incrementCounter)
            }
            
            Button(action: resetCounter) {
                Text("Reset")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    // MARK: - Intentions / Actions
    
    // 💡 Encapsulating logic in private functions to keep 'body' clean.
    // Since 'counter' is @State, mutating it automatically invalidates the view.
    private func incrementCounter() {
        counter += 1
    }
    
    private func decrementCounter() {
        counter -= 1
    }
    
    private func resetCounter() {
        counter = 0
    }
}

#Preview {
    ContentView()
}
