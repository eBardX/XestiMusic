// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPart {

    // MARK: Public Initializers

    public init(id: String,
                content: Content) {
        self.content = content
        self.id = id
    }

    // MARK: Public Instance Properties

    public let content: Content
    public let id: String
}

// MARK: - Codable

extension MXLPart: Codable {
}

// MARK: - Sendable

extension MXLPart: Sendable {
}
