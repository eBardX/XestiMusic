// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLNote {

    // MARK: Public Initializers

    public init(chord: Bool,
                value: Self.Value,
                duration: MXLDuration,
                tie: MXLTie) {
        self.chord = chord
        self.duration = duration
        self.tie = tie
        self.value = value
    }

    // MARK: Public Instance Properties

    public let chord: Bool
    public let duration: MXLDuration
    public let tie: MXLTie
    public let value: Self.Value
}

// MARK: - Sendable

extension MXLNote: Sendable {
}
