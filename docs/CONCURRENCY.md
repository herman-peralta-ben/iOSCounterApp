# Concurrency in Swift

### 🔄 Concurrency Equivalents

| Feature | **Swift** | **Dart (Flutter)** | **Kotlin (Android)** |
| :--- | :--- | :--- | :--- |
| **Execution Unit** | `Task { ... }` | `Future(() => ...)` | `launch { ... }` |
| **Awaiting Result** | `await task.value` | `await future` | `deferred.await()` |
| **Pending State** | `Task` (Object) | `Future` (Object) | `Job` / `Deferred` |
| **Cancellation** | `task.cancel()` | Not native | `job.cancel()` |
| **Threading** | Multi-threaded (Thread Pool) | Single-threaded (Event Loop) | Multi-threaded (Dispatchers) |
| **Structured Concurrency** | `TaskGroup` | `Future.wait()` | `coroutineScope` |

> **Note:** A Swift `Task` runs on a background thread pool by default, whereas a Dart `Future` runs on a single-threaded Event Loop unless you use `Isolates`.

