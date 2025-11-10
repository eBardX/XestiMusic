// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLMeasureTimewise {

    // MARK: Public Initializers

    public init(number: String,
                parts: [MXLPartTimewise]) {
        self.number = number
        self.parts = parts
    }

    // MARK: Public Instance Properties

    public let number: String
    public let parts: [MXLPartTimewise]
}

// MARK: - Codable

extension MXLMeasureTimewise: Codable {
}

// MARK: - Sendable

extension MXLMeasureTimewise: Sendable {
}
