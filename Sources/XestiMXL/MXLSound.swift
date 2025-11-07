// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLSound {

    // MARK: Public Initializers

    public init(id: String) {
        self.id = id
    }

    // MARK: Public Instance Properties

    public let id: String
}

// MARK: - Codable

extension MXLSound: Codable {
}

// MARK: - Sendable

extension MXLSound: Sendable {
}
