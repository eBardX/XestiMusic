// © 2025 John Gary Pusey (see LICENSE.md)

public enum SMFMetaMessage {
    case copyright(SMFText)
    case cuePoint(SMFText)
    case deviceName(SMFText)
    case endOfTrack
    case instrumentName(SMFText)
    case keySignature(SMFKeySignature)
    case lyric(SMFText)
    case marker(SMFText)
    case midiChannelPrefix(MIDIChannel)
    case midiPort(MIDIData1Value)
    case programName(SMFText)
    case sequenceNumber(SMFData2Value)
    case sequencerSpecific([UInt8])
    case sequenceTrackName(SMFText)
    case smpteOffset(SMPTETime)
    case tempo(SMFTempo)
    case text(SMFText)
    case timeSignature(SMFTimeSignature)
}

// MARK: -

extension SMFMetaMessage {

    // MARK: Public Initializers

    public init?(_ statusByte: UInt8,
                 _ typeByte: UInt8,
                 _ dataBytes: [UInt8]) {
        guard statusByte == 0xff
        else { return nil }

        switch typeByte {
        case 0x00:
            guard let seqNum = SMFData2Value(dataBytes)
            else { return nil }

            self = .sequenceNumber(seqNum)

        case 0x01...0x1f:
            guard let message = Self._makeTextMessage(typeByte,
                                                      dataBytes)
            else { return nil }

            self = message

        case 0x20:
            guard let channel = MIDIChannel(dataBytes)
            else { return nil }

            self = .midiChannelPrefix(channel)

        case 0x21:
            guard let port = MIDIData1Value(dataBytes)
            else { return nil }

            self = .midiPort(port)

        case 0x2f:
            self = .endOfTrack

        case 0x51:
            guard let tempo = SMFTempo(dataBytes)
            else { return nil }

            self = .tempo(tempo)

        case 0x54:
            guard let offset = SMPTETime(dataBytes)
            else { return nil }

            self = .smpteOffset(offset)

        case 0x58:
            guard let timeSig = SMFTimeSignature(dataBytes)
            else { return nil }

            self = .timeSignature(timeSig)

        case 0x59:
            guard let keySig = SMFKeySignature(dataBytes)
            else { return nil }

            self = .keySignature(keySig)

        case 0x7f:
            guard !dataBytes.isEmpty
            else { return nil }

            self = .sequencerSpecific(dataBytes)

        default:
            return nil
        }
    }

    // MARK: Public Instance Properties

    public var dataBytes: [UInt8]? {
        switch self {
        case let .copyright(text),
            let .cuePoint(text),
            let .deviceName(text),
            let .instrumentName(text),
            let .lyric(text),
            let .marker(text),
            let .programName(text),
            let .sequenceTrackName(text),
            let .text(text):
            text.bytesValue

        case .endOfTrack:
            []

        case let .keySignature(keySig):
            keySig.bytesValue

        case let .midiChannelPrefix(channel):
            channel.bytesValue

        case let .midiPort(port):
            port.bytesValue

        case let .sequenceNumber(seqNum):
            seqNum.bytesValue

        case let .sequencerSpecific(dataBytes):
            dataBytes

        case let .smpteOffset(offset):
            offset.bytesValue

        case let .tempo(tempo):
            tempo.bytesValue

        case let .timeSignature(timeSig):
            timeSig.bytesValue
        }
    }

    public var statusByte: UInt8? {
        0xff
    }

    public var typeByte: UInt8? {
        switch self {
        case .copyright:
            0x02

        case .cuePoint:
            0x07

        case .deviceName:
            0x09

        case .endOfTrack:
            0x2f

        case .instrumentName:
            0x04

        case .keySignature:
            0x59

        case .lyric:
            0x05

        case .marker:
            0x06

        case .midiChannelPrefix:
            0x20

        case .midiPort:
            0x21

        case .programName:
            0x08

        case .sequenceNumber:
            0x00

        case .sequencerSpecific:
            0x7f

        case .sequenceTrackName:
            0x03

        case .smpteOffset:
            0x54

        case .tempo:
            0x51

        case .text:
            0x01

        case .timeSignature:
            0x58
        }
    }

    // MARK: Private Type Methods

    private static func _makeTextMessage(_ typeByte: UInt8,
                                         _ dataBytes: [UInt8]) -> Self? {
        guard let text = SMFText(dataBytes)
        else { return nil }

        switch typeByte {
        case 0x01:
            return .text(text)

        case 0x02:
            return .copyright(text)

        case 0x03:
            return .sequenceTrackName(text)

        case 0x04:
            return .instrumentName(text)

        case 0x05:
            return .lyric(text)

        case 0x06:
            return .marker(text)

        case 0x07:
            return .cuePoint(text)

        case 0x08:
            return .programName(text)

        case 0x09:
            return .deviceName(text)

        default:
            return nil
        }
    }
}

// MARK: - Sendable

extension SMFMetaMessage: Sendable {
}
