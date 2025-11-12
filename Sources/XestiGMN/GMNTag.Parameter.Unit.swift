// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNTag.Parameter {
    public enum Unit: String {
        case cm   = "cm"
        case hs   = "hs"
        case `in` = "in"
        case m    = "m"
        case mm   = "mm"
        case pc   = "pc"
        case pt   = "pt"
        case rl   = "rl"
    }
}

// MARK: - Sendable

extension GMNTag.Parameter.Unit: Sendable {
}
