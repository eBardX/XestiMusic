// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPartPartwise {

    // MARK: Public Initializers

    public init(id: String,
                measures: [MXLMeasurePartwise]) {
        self.id = id
        self.measures = measures
    }

    // MARK: Public Instance Properties

    public let id: String
    public let measures: [MXLMeasurePartwise]
}

// MARK: - Sendable

extension MXLPartPartwise: Sendable {
}
