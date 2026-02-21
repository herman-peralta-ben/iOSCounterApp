import Foundation

public struct ErrorData: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let message: String

    public init(id: UUID = UUID(), title: String, message: String) {
        self.id = id
        self.title = title
        self.message = message
    }
}

enum CounterState {
    case idle
    case loading
    case success(Int)
    case error(ErrorData)
}

extension CounterState: Equatable {
    static func == (lhs: CounterState, rhs: CounterState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.error(let lhsMsg), .error(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}
