// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

public struct SMFParser {

    // MARK: Public Initializers

    public init(_ data: Data) {
        self.chunkBytesLeft = 0
        self.chunkMode = false
        self.currentIndex = 0
        self.currentTime = 0
        self.data = data
        self.runningStatus = 0
    }

    // MARK: Private Instance Properties

    private let data: Data

    private var chunkBytesLeft: UInt
    private var chunkMode: Bool
    private var currentIndex: Int
    private var currentTime: UInt
    private var runningStatus: UInt8
}

// MARK: -

extension SMFParser {

    // MARK: Public Instance Methods

    public mutating func parse() throws -> SMFSequence {
        guard let chunkType = try _parseChunk(),
              chunkType == .header
        else { throw Error.missingHeaderChunk }

        let (format, trackCount, division) = try _parseHeader()

        var tracks: [SMFTrack] = []

        while let chunkType = try _parseChunk() {
            switch chunkType {
            case .header:
                throw Error.tooManyHeaderChunks

            case .track:
                try tracks.append(_parseTrack())

            default:
                break   // ignore unknown chunks
            }

            try _skipExtraChunkData()
        }

        if tracks.count < trackCount {
            throw Error.notEnoughTrackChunks
        }

        if tracks.count > trackCount {
            throw Error.tooManyTrackChunks
        }

        return SMFSequence(format: format,
                           division: division,
                           tracks: tracks)
    }

    // MARK: Private Instance Methods

    private mutating func _parseByte() throws -> UInt8 {
        guard currentIndex < data.count,
              !chunkMode || chunkBytesLeft > 0
        else { throw Error.dataExhaustedPrematurely }

        let byte = data[currentIndex]

        currentIndex += 1

        if chunkMode {
            chunkBytesLeft -= 1
        }

        return byte
    }

    private mutating func _parseBytes(_ count: UInt) throws -> [UInt8] {
        var dataBytes: [UInt8] = []

        for _ in 0..<count {
            try dataBytes.append(_parseByte())
        }

        return dataBytes
    }

    private mutating func _parseChunk() throws -> SMFChunkType? {
        try _skipExtraChunkData()

        guard currentIndex < data.count
        else { return nil }

        chunkMode = false

        let chunkType = try _parseChunkType()

        chunkBytesLeft = try _parseChunkLength()

        currentTime = 0
        runningStatus = 0

        return chunkType
    }

    private mutating func _parseChunkLength() throws -> UInt {
        var chunkLength: UInt = 0

        for _ in 0..<4 {
            let byte = try _parseByte()

            chunkLength = (chunkLength << 8) | UInt(byte)
        }

        return chunkLength
    }

    private mutating func _parseChunkType() throws -> SMFChunkType {
        var rawChunkType = ""

        for _ in 0..<4 {
            let byte = try _parseByte()

            rawChunkType.append(Character(Unicode.Scalar(byte)))
        }

        guard let chunkType = SMFChunkType(stringValue: rawChunkType)
        else { throw Error.invalidChunkType(rawChunkType) }

        return chunkType
    }

    private mutating func _parseDivision() throws -> SMFDivision {
        let byte0Value = try _parseByte()
        let byte1Value = try _parseByte()

        guard let division = SMFDivision([byte0Value, byte1Value])
        else { throw Error.invalidDivision([byte0Value, byte1Value]) }

        return division
    }

    private mutating func _parseEvent() throws -> SMFEvent {
        let eventTime = try _parseEventTime()

        let (statusByte, extraBytes) = try _parseStatusByte()

        if statusByte.isMIDIEventStatusByte {
            return try _parseMIDIEvent(at: eventTime,
                                       statusByte: statusByte,
                                       extraBytes: extraBytes)
        }

        if statusByte.isMetaEventStatusByte {
            return try _parseMetaEvent(at: eventTime,
                                       statusByte: statusByte)
        }

        if statusByte.isSysExEventStatusByte {
            return try _parseSysExEvent(at: eventTime,
                                        statusByte: statusByte)
        }

        throw Error.unknownEventStatus(statusByte)
    }

    private mutating func _parseEventTime() throws -> SMFEventTime {
        currentTime += try _parseVarlen()

        guard let eventTime = SMFEventTime(uintValue: currentTime)
        else { throw Error.invalidEventTime(currentTime) }

        return eventTime
    }

    private mutating func _parseFormat() throws -> SMFFormat {
        let byte0Value = try _parseByte()
        let byte1Value = try _parseByte()

        guard let format = SMFFormat([byte0Value, byte1Value])
        else { throw Error.invalidFormat([byte0Value, byte1Value]) }

        return format
    }

    private mutating func _parseHeader() throws -> (SMFFormat, UInt, SMFDivision) {
        chunkMode = true

        let format = try _parseFormat()
        let trackCount = try _parseTrackCount(for: format)
        let division = try _parseDivision()

        return (format, trackCount, division)
    }

    private mutating func _parseMetaEvent(at eventTime: SMFEventTime,
                                          statusByte: UInt8) throws -> SMFEvent {
        let typeByte = try _parseByte()
        let count = try _parseVarlen()
        let dataBytes = try _parseBytes(count)

        guard let message = SMFMetaMessage(statusByte, typeByte, dataBytes)
        else { throw Error.invalidMetaMessage(statusByte, typeByte, dataBytes) }

        runningStatus = 0

        return .meta(eventTime, message)
    }

    private mutating func _parseMIDIEvent(at eventTime: SMFEventTime,
                                          statusByte: UInt8,
                                          extraBytes: [UInt8]) throws -> SMFEvent {
        guard let edbCount = MIDIChannelMessage.expectedDataByteCount(for: statusByte)
        else { throw Error.unknownChannelMessageStatus(statusByte) }

        var dataBytes = extraBytes

        while dataBytes.count < edbCount {
            try dataBytes.append(_parseByte())
        }

        guard let message = MIDIChannelMessage(statusByte, dataBytes)
        else { throw Error.invalidChannelMessage(statusByte, dataBytes) }

        runningStatus = statusByte

        return .midi(eventTime, message)
    }

    private mutating func _parseStatusByte() throws -> (UInt8, [UInt8]) {
        let tmpByte = try _parseByte()

        if tmpByte.isMIDIStatusByte {
            return (tmpByte, [])
        }

        if runningStatus.isMIDIStatusByte {
            return (runningStatus, [tmpByte])
        }

        throw Error.unexpectedDataByte(tmpByte)
    }

    private mutating func _parseSysExEvent(at eventTime: SMFEventTime,
                                           statusByte: UInt8) throws -> SMFEvent {
        let count = try _parseVarlen()
        let dataBytes = try _parseBytes(count)

        guard let message = SMFSysExMessage(statusByte, dataBytes)
        else { throw Error.invalidSysExMessage(statusByte, dataBytes) }

        runningStatus = 0

        return .sysEx(eventTime, message)
    }

    private mutating func _parseTrack() throws -> SMFTrack {
        chunkMode = true

        var events: [SMFEvent] = []

        while chunkBytesLeft > 0 {
            try events.append(_parseEvent())
        }

        guard !events.isEmpty
        else { throw Error.emptyTrack }

        return SMFTrack(events: events)
    }

    private mutating func _parseTrackCount(for format: SMFFormat) throws -> UInt {
        let byte0Value = try _parseByte()
        let byte1Value = try _parseByte()

        let trackCount = UInt(byte0Value) << 8 | UInt(byte1Value)

        guard (format == .format0 && trackCount == 1) ||
                (format != .format0 && (1...0x7fff).contains(trackCount))
        else { throw Error.invalidTrackCount(trackCount, format) }

        return trackCount
    }

    private mutating func _parseVarlen() throws -> UInt {
        var varlen: UInt = 0

        while true {
            let byte = try _parseByte()

            varlen = (varlen << 7) + UInt(byte & 0x7f)

            if byte & 0x80 == 0 {
                break
            }
        }

        return varlen
    }

    private mutating func _skipExtraChunkData() throws {
        guard chunkBytesLeft > 0
        else { return }

        guard currentIndex + Int(chunkBytesLeft) <= data.count
        else { throw Error.dataExhaustedPrematurely }

        currentIndex += Int(chunkBytesLeft)

        chunkBytesLeft = 0
    }
}
