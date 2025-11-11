// © 2025 John Gary Pusey (see LICENSE.md)

public enum SMFKeySignature {
    case aFlatMajor
    case aFlatMinor
    case aMajor
    case aMinor
    case aSharpMinor
    case bFlatMajor
    case bFlatMinor
    case bMajor
    case bMinor
    case cFlatMajor
    case cMajor
    case cMinor
    case cSharpMajor
    case cSharpMinor
    case dFlatMajor
    case dMajor
    case dMinor
    case dSharpMinor
    case eFlatMajor
    case eFlatMinor
    case eMajor
    case eMinor
    case fMajor
    case fMinor
    case fSharpMajor
    case fSharpMinor
    case gFlatMajor
    case gMajor
    case gMinor
    case gSharpMinor
}

// MARK: - BytesValueConvertible

extension SMFKeySignature: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 2
        else { return nil }

        switch (bytesValue[0], bytesValue[1]) {
        case (0x00, 0x00):
            self = .cMajor

        case (0x00, 0x01):
            self = .aMinor

        case (0x01, 0x00):
            self = .gMajor

        case (0x01, 0x01):
            self = .eMinor

        case (0x02, 0x00):
            self = .dMajor

        case (0x02, 0x01):
            self = .bMinor

        case (0x03, 0x00):
            self = .aMajor

        case (0x03, 0x01):
            self = .fSharpMinor

        case (0x04, 0x00):
            self = .eMajor

        case (0x04, 0x01):
            self = .cSharpMinor

        case (0x05, 0x00):
            self = .bMajor

        case (0x05, 0x01):
            self = .gSharpMinor

        case (0x06, 0x00):
            self = .fSharpMajor

        case (0x06, 0x01):
            self = .dSharpMinor

        case (0x07, 0x00):
            self = .cSharpMajor

        case (0x07, 0x01):
            self = .aSharpMinor

        case (0xf9, 0x00):
            self = .cFlatMajor

        case (0xf9, 0x01):
            self = .aFlatMinor

        case (0xfa, 0x00):
            self = .gFlatMajor

        case (0xfa, 0x01):
            self = .eFlatMinor

        case (0xfb, 0x00):
            self = .dFlatMajor

        case (0xfb, 0x01):
            self = .bFlatMinor

        case (0xfc, 0x00):
            self = .aFlatMajor

        case (0xfc, 0x01):
            self = .fMinor

        case (0xfd, 0x00):
            self = .eFlatMajor

        case (0xfd, 0x01):
            self = .cMinor

        case (0xfe, 0x00):
            self = .bFlatMajor

        case (0xfe, 0x01):
            self = .gMinor

        case (0xff, 0x00):
            self = .fMajor

        case (0xff, 0x01):
            self = .dMinor

        default:
            return nil
        }
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        switch self {
        case .aFlatMajor:
            [0xfc, 0x00]

        case .aFlatMinor:
            [0xf9, 0x01]

        case .aMajor:
            [0x03, 0x00]

        case .aMinor:
            [0x00, 0x01]

        case .aSharpMinor:
            [0x07, 0x01]

        case .bFlatMajor:
            [0xfe, 0x00]

        case .bFlatMinor:
            [0xfb, 0x01]

        case .bMajor:
            [0x05, 0x00]

        case .bMinor:
            [0x02, 0x01]

        case .cFlatMajor:
            [0xf9, 0x00]

        case .cMajor:
            [0x00, 0x00]

        case .cMinor:
            [0xfd, 0x01]

        case .cSharpMajor:
            [0x07, 0x00]

        case .cSharpMinor:
            [0x04, 0x01]

        case .dFlatMajor:
            [0xfb, 0x00]

        case .dMajor:
            [0x02, 0x00]

        case .dMinor:
            [0xff, 0x01]

        case .dSharpMinor:
            [0x06, 0x01]

        case .eFlatMajor:
            [0xfd, 0x00]

        case .eFlatMinor:
            [0xfa, 0x01]

        case .eMajor:
            [0x04, 0x00]

        case .eMinor:
            [0x01, 0x01]

        case .fMajor:
            [0xff, 0x00]

        case .fMinor:
            [0xfc, 0x01]

        case .fSharpMajor:
            [0x06, 0x00]

        case .fSharpMinor:
            [0x03, 0x01]

        case .gFlatMajor:
            [0xfa, 0x00]

        case .gMajor:
            [0x01, 0x00]

        case .gMinor:
            [0xfe, 0x01]

        case .gSharpMinor:
            [0x05, 0x01]
        }
    }
}

// MARK: - Sendable

extension SMFKeySignature: Sendable {
}
