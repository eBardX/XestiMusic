// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTune {

    // MARK: Public Initializers

    public init(_ name: String) {
        self.name = name
    }

    // MARK: Public Instance Properties

    public let name: String
}

// MARK: - Sendable

extension ABCTune: Sendable {
}
