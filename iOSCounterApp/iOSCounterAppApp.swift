import SwiftUI
import Data

@main
struct iOSCounterAppApp: App {
    let sharedRepository = CounterInMemoryRepository(
        initialCount: 5,
        enableResetFailure: true,
    )
    
    var body: some Scene {
        WindowGroup {
            // 💡 Manual Dependency Injection
            ContentView(repository: sharedRepository)
        }
    }
}
