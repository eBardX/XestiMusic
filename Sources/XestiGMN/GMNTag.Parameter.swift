// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNTag {
    public enum Parameter {
        case floating(String?, Double, Unit?)
        case integer(String?, Int, Unit?)
        case parameter(String?, String)
        case string(String?, String)
        case variable(String?, String)
    }
}

// MARK: -

extension GMNTag.Parameter {

    // MARK: Public Instance Properties

    public var floatingValue: Double? {
        switch self {
        case let .floating(_, value, _):
            value

        default:
            nil
        }
    }

    public var integerValue: Int? {
        switch self {
        case let .integer(_, value, _):
            value

        default:
            nil
        }
    }

    public var name: String? {
        switch self {
        case let .floating(name, _, _),
            let .integer(name, _, _),
            let .parameter(name, _),
            let .string(name, _),
            let .variable(name, _):
            name
        }
    }

    public var stringValue: String? {
        switch self {
        case let .string(_, value):
            value

        default:
            nil
        }
    }

    public var unit: Unit? {
        switch self {
        case let .floating(_, _, unit),
            let .integer(_, _, unit):
            unit

        default:
            nil
        }
    }

    // MARK: Public Instance Method

    public func hasNameOrNil(_ pname: String) -> Bool {
        guard let name
        else { return true }

        return name == pname
    }
}

// MARK: - Sendable

extension GMNTag.Parameter: Sendable {
}
