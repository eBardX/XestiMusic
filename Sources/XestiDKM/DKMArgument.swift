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

// MARK: - Codable

extension DKMArgument: Codable {

    // MARK: Public Initializers

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Double.self) {
            self.init(value)
        } else if let value = try? container.decode(String.self) {
            self.init(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Invalid DKM argument value")
        }
    }

    // MARK: Public Instance Methods

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .double(value):
            try container.encode(value)

        case let .string(value):
            try container.encode(value)
        }
    }
}

// MARK: - Sendable

extension DKMArgument: Sendable {
}
