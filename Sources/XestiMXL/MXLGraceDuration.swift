// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLGraceDuration {
    case makeTime(Float)
    case stealTimeFollowing(Float)
    case stealTimePrevious(Float)
    case unspecified
}

// MARK: - Sendable

extension MXLGraceDuration: Sendable {
}
