// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLOpus {
    public enum Item {
        case opus(MXLOpus)
        case opusLink(String)
        case score(String)
    }
}

// MARK: - Sendable

extension MXLOpus.Item: Sendable {
}
