// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTune {

    // MARK: Public Initializers

    public init(entries: [ABCEntry]) {
        self.entries = entries
    }

    // MARK: Public Instance Properties

    public let entries: [ABCEntry]
}

// MARK: - Sendable

extension ABCTune: Sendable {
}
