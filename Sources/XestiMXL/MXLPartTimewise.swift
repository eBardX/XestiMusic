// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPartTimewise {

    // MARK: Public Initializers

    public init(id: String,
                items: [MXLMusicItem]) {
        self.id = id
        self.items = items
    }

    // MARK: Public Instance Properties

    public let id: String
    public let items: [MXLMusicItem]
}

// MARK: - Sendable

extension MXLPartTimewise: Sendable {
}
