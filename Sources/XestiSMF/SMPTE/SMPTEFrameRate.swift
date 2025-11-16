public enum SMPTEFrameRate {
    case fps24
    case fps25
    case fps2997
    case fps30
}

// MARK: -

extension SMPTEFrameRate {

    // MARK: Public Instance Properties

    public var uintValue: UInt {
        switch self {
        case .fps24:
            24

        case .fps25:
            25

        case .fps2997, .fps30:
            30
        }
    }
}

// MARK: - Sendable

extension SMPTEFrameRate: Sendable {
}
