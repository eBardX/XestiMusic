// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLStandardSound {

    // MARK: Public Initializers

    public init(id: String) {
        self.id = id
    }

    // MARK: Public Instance Properties

    public let id: String
}

// MARK: - Codable

extension MXLStandardSound: Codable {
}

// MARK: - Sendable

extension MXLStandardSound: Sendable {
}
