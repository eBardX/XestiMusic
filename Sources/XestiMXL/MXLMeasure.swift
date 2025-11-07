// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLMeasure {

    // MARK: Public Initializers

    public init(number: String,
                content: Content) {
        self.content = content
        self.number = number
    }

    // MARK: Public Instance Properties

    public let content: Content
    public let number: String
}

// MARK: - Codable

extension MXLMeasure: Codable {
}

// MARK: - Sendable

extension MXLMeasure: Sendable {
}
