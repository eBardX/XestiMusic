// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLPart {
    public enum Content {
        case partwise([MXLMeasure])
        case timewise([MXLMusicItem])
    }
}

// MARK: - Codable

extension MXLPart.Content: Codable {
}

// MARK: - Sendable

extension MXLPart.Content: Sendable {
}
