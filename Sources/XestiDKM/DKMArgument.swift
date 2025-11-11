// © 2025 John Gary Pusey (see LICENSE.md)

public enum DKMArgument {
    case double(Double)
    case string(String)
}

// MARK: -

extension DKMArgument {

    // MARK: Public Initializers

    public init(_ value: Any) {
        switch value {
        case let value as Double:
            self = .double(value)

        case let value as String:
            self = .string(value)

        default:
            self = .string("\(value)")
        }
    }

    // MARK: Public Instance Properties

    public var value: Any {
        switch self {
        case let .double(value):
            return value

        case let .string(value):
            return value
        }
    }
}

// MARK: - Sendable

extension DKMArgument: Sendable {
}
