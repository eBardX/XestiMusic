// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLStandardSound {

    // MARK: Public Initializers

    public init(id: String) {
        self.id = id
    }

    // MARK: Public Instance Properties

    public let id: String
}

// MARK: - Sendable

extension MXLStandardSound: Sendable {
}
