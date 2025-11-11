public enum SMPTEFrameRate {
    case fps24
    case fps25
    case fps30df
    case fps30ndf
}

// MARK: - Sendable

extension SMPTEFrameRate: Sendable {
}
