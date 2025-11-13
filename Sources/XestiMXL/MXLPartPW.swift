// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPartPW {

    // MARK: Public Initializers

    public init(id: String,
                measures: [MXLMeasurePW]) {
        self.id = id
        self.measures = measures
    }

    // MARK: Public Instance Properties

    public let id: String
    public let measures: [MXLMeasurePW]
}

// MARK: - Sendable

extension MXLPartPW: Sendable {
}
