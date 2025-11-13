// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLMeasureTW {

    // MARK: Public Initializers

    public init(number: String,
                parts: [MXLPartTW]) {
        self.number = number
        self.parts = parts
    }

    // MARK: Public Instance Properties

    public let number: String
    public let parts: [MXLPartTW]
}

// MARK: - Sendable

extension MXLMeasureTW: Sendable {
}
