// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLGraceNote {

    // MARK: Public Initializers

    public init(isChord: Bool,
                value: MXLNote.Value,
                duration: MXLGraceDuration,
                tie: MXLTie) {
        self.duration = duration
        self.isChord = isChord
        self.tie = tie
        self.value = value
    }

    // MARK: Public Instance Properties

    public let duration: MXLGraceDuration
    public let isChord: Bool
    public let tie: MXLTie
    public let value: MXLNote.Value
}

// MARK: - Sendable

extension MXLGraceNote: Sendable {
}
