// © 2025 John Gary Pusey (see LICENSE.md)

public enum MIDIChannelMessage {
    case channelPressure(MIDIChannel, MIDIData1Value)
    case controlChange(MIDIChannel, MIDIController, MIDIData1Value)
    case noteOff(MIDIChannel, MIDIData1Value, MIDIData1Value)
    case noteOn(MIDIChannel, MIDIData1Value, MIDIData1Value)
    case pitchBendChange(MIDIChannel, MIDIPitchBend)
    case polyphonicPressure(MIDIChannel, MIDIData1Value, MIDIData1Value)
    case programChange(MIDIChannel, MIDIData1Value)
}

// MARK: -

extension MIDIChannelMessage {

    // MARK: Public Type Methods

    public static func expectedDataByteCount(for statusByte: UInt8) -> Int? {
        switch statusByte & 0xf0 {
        case 0x80, 0x90, 0xa0, 0xb0, 0xe0:
            2

        case 0xc0, 0xd0:
            1

        default:
            nil
        }
    }

    public static func isModeMessage(_ statusByte: UInt8,
                                     _ dataBytes: [UInt8]) -> Bool {
        guard (statusByte & 0xf0) == 0xb0,
              let dataByte = dataBytes.first,
              (121...127).contains(dataByte)
        else { return false }

        return true
    }

    public static func isVoiceMessage(_ statusByte: UInt8,
                                      _ dataBytes: [UInt8]) -> Bool {
        guard (0x80..<0xf0).contains(statusByte & 0xf0),
              !isModeMessage(statusByte, dataBytes)
        else { return false }

        return true
    }

    // MARK: Public Initializers

    public init?(_ statusByte: UInt8,
                 _ dataBytes: [UInt8]) {
        guard let edbCount = Self.expectedDataByteCount(for: statusByte),
              edbCount == dataBytes.count,
              dataBytes.allSatisfy({ $0.isMIDIDataByte }),
              let channel = MIDIChannel([statusByte & 0x0f])
        else { return nil }

        switch statusByte & 0xf0 {
        case 0x80:
            guard let note = MIDIData1Value([dataBytes[0]]),
                  let velocity = MIDIData1Value([dataBytes[1]])
            else { return nil }

            self = .noteOff(channel, note, velocity)

        case 0x90:
            guard let note = MIDIData1Value([dataBytes[0]]),
                  let velocity = MIDIData1Value([dataBytes[1]])
            else { return nil }

            self = .noteOn(channel, note, velocity)

        case 0xa0:
            guard let note = MIDIData1Value([dataBytes[0]]),
                  let velocity = MIDIData1Value([dataBytes[1]])
            else { return nil }

            self = .polyphonicPressure(channel, note, velocity)

        case 0xb0:
            guard let controller = MIDIController([dataBytes[0]]),
                  let controlValue = MIDIData1Value([dataBytes[1]])
            else { return nil }

            self = .controlChange(channel, controller, controlValue)

        case 0xc0:
            guard let program = MIDIData1Value([dataBytes[0]])
            else { return nil }

            self = .programChange(channel, program)

        case 0xd0:
            guard let velocity = MIDIData1Value([dataBytes[0]])
            else { return nil }

            self = .channelPressure(channel, velocity)

        case 0xe0:
            guard let pitchBend = MIDIPitchBend(Array(dataBytes[0...1]))
            else { return nil }

            self = .pitchBendChange(channel, pitchBend)

        default:
            return nil
        }
    }

    // MARK: Public Instance Properties

    public var channel: MIDIChannel {
        switch self {
        case let .channelPressure(channel, _),
            let .controlChange(channel, _, _),
            let .noteOff(channel, _, _),
            let .noteOn(channel, _, _),
            let .pitchBendChange(channel, _),
            let .polyphonicPressure(channel, _, _),
            let .programChange(channel, _):
            channel
        }
    }

    public var dataBytes: [UInt8]? {
        switch self {
        case let .channelPressure(_, velocity):
            velocity.bytesValue

        case let .controlChange(_, controller, controlValue):
            _combine(controller, controlValue)

        case let .noteOff(_, note, velocity):
            _combine(note, velocity)

        case let .noteOn(_, note, velocity):
            _combine(note, velocity)

        case let .pitchBendChange(_, pitchBend):
            pitchBend.bytesValue

        case let .polyphonicPressure(_, note, velocity):
            _combine(note, velocity)

        case let .programChange(_, program):
            program.bytesValue
        }
    }

    public var statusByte: UInt8? {
        switch self {
        case let .channelPressure(channel, _):
            _combine(0xd0, channel)

        case let .controlChange(channel, _, _):
            _combine(0xb0, channel)

        case let .noteOff(channel, _, _):
            _combine(0x80, channel)

        case let .noteOn(channel, _, _):
            _combine(0x90, channel)

        case let .pitchBendChange(channel, _):
            _combine(0xe0, channel)

        case let .polyphonicPressure(channel, _, _):
            _combine(0xa0, channel)

        case let .programChange(channel, _):
            _combine(0xc0, channel)
        }
    }

    // MARK: Private Instance Methods

    private func _combine(_ statusByte: UInt8,
                          _ channel: MIDIChannel) -> UInt8? {
        guard let channelByte = channel.bytesValue?.first
        else { return nil }

        return statusByte | channelByte
    }

    private func _combine(_ value1: any BytesValueConvertible,
                          _ value2: any BytesValueConvertible) -> [UInt8]? {
        guard let bytesValue1 = value1.bytesValue,
              let bytesValue2 = value2.bytesValue
        else { return nil }

        return bytesValue1 + bytesValue2
    }
}

// MARK: - Sendable

extension MIDIChannelMessage: Sendable {
}
