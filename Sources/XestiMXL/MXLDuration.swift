// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLDuration {
    case divisions(Int)
    case makeTime(Float)
    case stealFollowing(Float)
    case stealPrevious(Float)
    case unspecified
}

// MARK: - Sendable

extension MXLDuration: Sendable {
}
