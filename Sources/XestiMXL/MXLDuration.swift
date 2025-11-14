// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLDuration {
    case divisions(Int)
    case makeTime(Float)
    case stealFollowing(Float)
    case stealPrevious(Float)
    case unspecified
}

// MARK: -

extension MXLDuration {

    // MARK: Public Instance Properties

    public var divisions: Int? {
        switch self {
        case let .divisions(divisions):
            divisions

        default:
            nil
        }
    }
}

// MARK: - Sendable

extension MXLDuration: Sendable {
}
