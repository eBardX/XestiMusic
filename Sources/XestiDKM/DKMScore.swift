// © 2025 John Gary Pusey (see LICENSE.md)

public struct DKMScore {

    // MARK: Public Initializers

    public init(_ entries: [DKMEntry]) {
        self.entries = entries
    }

    // MARK: Public Instance Properties

    public let entries: [DKMEntry]
}

// MARK: - Codable

extension DKMScore: Codable {
}

// MARK: - Sendable

extension DKMScore: Sendable {
}
