// © 2025 John Gary Pusey (see LICENSE.md)

public enum MIDISystemMessage {
    case activeSensing
    case `continue`
    case eox
    case mtcQuarterFrame(MIDIData1Value)
    case songPosition(MIDIData2Value)
    case songSelect(MIDIData1Value)
    case start
    case stop
    case systemExclusive([UInt8])
    case systemReset
    case timingClock
    case tuneRequest
}

// MARK: -

extension MIDISystemMessage {

    // MARK: Public Type Methods

    public static func isCommonMessage(_ statusByte: UInt8) -> Bool {
        (0xf1...0xf7).contains(statusByte)
    }

    public static func isExclusiveMessage(_ statusByte: UInt8) -> Bool {
        statusByte == 0xf0
    }

    public static func isRealTimeMessage(_ statusByte: UInt8) -> Bool {
        (0xf8...0xff).contains(statusByte)
    }

    // MARK: Public Initializers

    public init?(_ statusByte: UInt8,
                 _ dataBytes: [UInt8]) {
        switch statusByte {
        case 0xf0:
            guard let message = Self._makeExclusiveMessage(statusByte, dataBytes)
            else { return nil }

            self = message

        case 0xf1...0xf7:
            guard let message = Self._makeCommonMessage(statusByte, dataBytes)
            else { return nil }

            self = message

        case 0xf8...0xff:
            guard let message = Self._makeRealTimeMessage(statusByte, dataBytes)
            else { return nil }

            self = message

        default:
            return nil
        }
    }

    // MARK: Public Instance Properties

    public var dataBytes: [UInt8]? {
        switch self {
        case .activeSensing,
                .continue,
                .eox,
                .start,
                .stop,
                .systemReset,
                .timingClock,
                .tuneRequest:
            []

        case let .mtcQuarterFrame(value):
            value.bytesValue

        case let .songPosition(position):
            position.bytesValue

        case let .songSelect(song):
            song.bytesValue

        case let .systemExclusive(dataBytes):
            // should validate dataBytes first…

            dataBytes
        }
    }

    public var statusByte: UInt8? {
        switch self {
        case .activeSensing:
            0xfe

        case .continue:
            0xfb

        case .eox:
            0xf7

        case .mtcQuarterFrame:
            0xf1

        case .songPosition:
            0xf2

        case .songSelect:
            0xf3

        case .start:
            0xfa

        case .stop:
            0xfc

        case .systemExclusive:
            0xf0

        case .systemReset:
            0xff

        case .timingClock:
            0xf8

        case .tuneRequest:
            0xf6
        }
    }

    // MARK: Private Type Methods

    private static func _makeCommonMessage(_ statusByte: UInt8,
                                           _ dataBytes: [UInt8]) -> Self? {
        guard dataBytes.allSatisfy({ $0.isMIDIDataByte })
        else { return nil }

        switch statusByte {
        case 0xf1:
            guard let value = MIDIData1Value(dataBytes)
            else { return nil }

            return .mtcQuarterFrame(value)

        case 0xf2:
            guard let position = MIDIData2Value(dataBytes)
            else { return nil }

            return .songPosition(position)

        case 0xf3:
            guard let song = MIDIData1Value(dataBytes)
            else { return nil }

            return .songSelect(song)

        case 0xf6:
            guard dataBytes.isEmpty
            else { return nil }

            return .tuneRequest

        case 0xf7:
            guard dataBytes.isEmpty
            else { return nil }

            return .eox

        default:
            return nil
        }
    }

    private static func _makeExclusiveMessage(_ statusByte: UInt8,
                                              _ dataBytes: [UInt8]) -> Self? {
        guard statusByte == 0xf0,
              dataBytes.count > 1,
              dataBytes.dropLast().allSatisfy({ $0.isMIDIDataByte }),
              let eoxByte = dataBytes.last,
              eoxByte == 0xf7
        else { return nil }

        return .systemExclusive(dataBytes)
    }

    private static func _makeRealTimeMessage(_ statusByte: UInt8,
                                             _ dataBytes: [UInt8]) -> Self? {
        guard dataBytes.isEmpty
        else { return nil }

        switch statusByte {
        case 0xf8:
            return .timingClock

        case 0xfa:
            return .start

        case 0xfb:
            return .continue

        case 0xfc:
            return .stop

        case 0xfe:
            return .activeSensing

        case 0xff:
            return .systemReset

        default:
            return nil
        }
    }
}

// MARK: - Codable

extension MIDISystemMessage: Codable {
}

// MARK: - Sendable

extension MIDISystemMessage: Sendable {
}
