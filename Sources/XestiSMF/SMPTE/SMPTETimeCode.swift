public struct SMPTETimeCode {

    // MARK: Public Initializers

    public init?(frameRate: SMPTEFrameRate,
                 tickRate: UInt) {
        guard (0...255).contains(tickRate)
        else { return nil }

        self.frameRate = frameRate
        self.tickRate = tickRate
    }

    // MARK: Public Instance Properties

    public let frameRate: SMPTEFrameRate
    public let tickRate: UInt
}

// MARK: - BytesValueConvertible

extension SMPTETimeCode: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 2,
              let frameRate = Self._convertToFrameRate(bytesValue[0])
        else { return nil }

        self.init(frameRate: frameRate,
                  tickRate: UInt(bytesValue[1]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = Self._convertToByteValue(frameRate),
              let byte1Value = UInt8(exactly: tickRate)
        else { return nil }

        return [byte0Value, byte1Value]
    }

    // MARK: Private Type Methods

    private static func _convertToByteValue(_ frameRate: SMPTEFrameRate) -> UInt8? {
        switch frameRate {
        case .fps24:
            0xe8

        case .fps25:
            0xe7

        case .fps30df:
            0xe3

        case .fps30ndf:
            0xe2
        }
    }

    private static func _convertToFrameRate(_ byteValue: UInt8) -> SMPTEFrameRate? {
        switch byteValue {
        case 0xe8:
            .fps24

        case 0xe7:
            .fps25

        case 0xe3:
            .fps30df

        case 0xe2:
            .fps30ndf

        default:
            nil
        }
    }
}

// MARK: - Sendable

extension SMPTETimeCode: Sendable {
}
