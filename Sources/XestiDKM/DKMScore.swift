// © 2025 John Gary Pusey (see LICENSE.md)

public struct DKMScore {

    // MARK: Public Initializers

    public init(entries: [DKMEntry]) {
        self.entries = entries
    }

    // MARK: Public Instance Properties

    public let entries: [DKMEntry]
}

// MARK: - Sendable

extension DKMScore: Sendable {
}
