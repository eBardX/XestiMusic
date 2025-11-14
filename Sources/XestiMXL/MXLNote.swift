// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLNote {

    // MARK: Public Initializers

    public init(isChord: Bool,
                value: Self.Value,
                duration: MXLDuration,
                tie: MXLTie) {
        self.duration = duration
        self.isChord = isChord
        self.tie = tie
        self.value = value
    }

    // MARK: Public Instance Properties

    public let duration: MXLDuration
    public let isChord: Bool
    public let tie: MXLTie
    public let value: Self.Value
}

// MARK: -

extension MXLNote {

    // MARK: Public Instance Properties

    public var isGrace: Bool {
        duration.divisions == nil
    }
}

// MARK: - Sendable

extension MXLNote: Sendable {
}
