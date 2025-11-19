// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCVersion {

    // MARK: Public Type Properties

    public static let currentMajor: UInt = 2
    public static let currentMinor: UInt = 1

    // MARK: Public Initializers

    public init(major: UInt,
                minor: UInt) {
        self.major = major
        self.minor = minor
    }

    // MARK: Public Instance Properties

    public let major: UInt
    public let minor: UInt
}

// MARK: - Sendable

extension ABCVersion: Sendable {
}
