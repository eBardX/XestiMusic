// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLMeasure {
    public enum Content {
        case partwise([MXLMusicItem])
        case timewise([MXLPart])
    }
}

// MARK: - Codable

extension MXLMeasure.Content: Codable {
}

// MARK: - Sendable

extension MXLMeasure.Content: Sendable {
}
