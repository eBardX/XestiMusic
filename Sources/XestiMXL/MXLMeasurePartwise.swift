// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLMeasurePartwise {

    // MARK: Public Initializers

    public init(number: String,
                items: [MXLMusicItem]) {
        self.items = items
        self.number = number
    }

    // MARK: Public Instance Properties

    public let items: [MXLMusicItem]
    public let number: String
}

// MARK: - Sendable

extension MXLMeasurePartwise: Sendable {
}
