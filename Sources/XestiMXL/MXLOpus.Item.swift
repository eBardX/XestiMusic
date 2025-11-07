// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLOpus {
    public enum Item {
        case opus(MXLOpus)
        case opusLink(String)
        case score(String)
    }
}

// MARK: - Codable

extension MXLOpus.Item: Codable {
}

// MARK: - Sendable

extension MXLOpus.Item: Sendable {
}
