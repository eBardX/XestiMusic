// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPartList {

    // MARK: Public Initializers

    public init(scoreParts: [MXLScorePart]) {
        self.scoreParts = scoreParts
    }

    // MARK: Public Instance Properties

    public let scoreParts: [MXLScorePart]
}

// MARK: - Sendable

extension MXLPartList: Sendable {
}
