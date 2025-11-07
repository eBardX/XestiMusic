// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCNote {

    // MARK: Public Initializers

    public init(_ pitch: ABCPitch,
                _ duration: ABCFraction,
                _ isTied: Bool) {
        self.duration = duration
        self.isTied = isTied
        self.pitch = pitch
    }

    // MARK: Public Instance Properties

    public let pitch: ABCPitch
    public let duration: ABCFraction
    public let isTied: Bool
}

// MARK: - Sendable

extension ABCNote: Sendable {
}
