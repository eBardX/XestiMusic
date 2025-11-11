public struct SMPTETime {

    // MARK: Public Initializers

    public init?(frameRate: SMPTEFrameRate,
                 hour: UInt,
                 minute: UInt,
                 second: UInt,
                 frame: UInt,
                 fraction: UInt) {
        guard let maxFrame = Self._maximumFrame(for: frameRate),
              (0...23).contains(hour),
              (0...59).contains(minute),
              (0...59).contains(second),
              (0...maxFrame).contains(frame),
              (0...99).contains(fraction)
        else { return nil }

        self.fraction = fraction
        self.frame = frame
        self.frameRate = frameRate
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    // MARK: Public Instance Proprties

    public let fraction: UInt
    public let frame: UInt
    public let frameRate: SMPTEFrameRate
    public let hour: UInt
    public let minute: UInt
    public let second: UInt

    // MARK: Private Type Methods

    private static func _maximumFrame(for frameRate: SMPTEFrameRate) -> UInt? {
        switch frameRate {
        case .fps24:
            23

        case .fps25:
            24

        case .fps30df:
            28

        case .fps30ndf:
            29
        }
    }
}

// MARK: - BytesValueConvertible

extension SMPTETime: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 5,
              let frameRate = Self._convertToFrameRate(UInt(bytesValue[0] >> 5))
        else { return nil }

        self.init(frameRate: frameRate,
                  hour: UInt(bytesValue[0] & 0x1f),
                  minute: UInt(bytesValue[1]),
                  second: UInt(bytesValue[2]),
                  frame: UInt(bytesValue[3]),
                  fraction: UInt(bytesValue[4]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0ValueHi = Self._convertToBits(frameRate),
              let byte0ValueLo = UInt8(exactly: hour),
              let byte1Value = UInt8(exactly: minute),
              let byte2Value = UInt8(exactly: second),
              let byte3Value = UInt8(exactly: frame),
              let byte4Value = UInt8(exactly: fraction)
        else { return nil }

        return [(byte0ValueHi << 5) | byte0ValueLo,
                byte1Value,
                byte2Value,
                byte3Value,
                byte4Value]
    }

    // MARK: Private Type Methods

    private static func _convertToBits(_ frameRate: SMPTEFrameRate) -> UInt8? {
        switch frameRate {
        case .fps24:
            0

        case .fps25:
            1

        case .fps30df:
            2

        case .fps30ndf:
            3
        }
    }

    private static func _convertToFrameRate(_ bits: UInt) -> SMPTEFrameRate? {
        switch bits {
        case 0:
            .fps24

        case 1:
            .fps25

        case 2:
            .fps30df

        case 3:
            .fps30ndf

        default:
            nil
        }
    }
}

// MARK: - Sendable

extension SMPTETime: Sendable {
}
