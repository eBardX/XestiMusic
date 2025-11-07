// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLScore {
    public enum Content {
        case partwise([MXLPart])
        case timewise([MXLMeasure])
    }
}

// MARK: - Codable

extension MXLScore.Content: Codable {
}

// MARK: - Sendable

extension MXLScore.Content: Sendable {
}
