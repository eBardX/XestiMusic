// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension SMFParser {
    public enum Error {
        case dataExhaustedPrematurely
        case emptyTrack
        case invalidChannelMessage(UInt8, [UInt8])
        case invalidChunkType(String)
        case invalidDivision([UInt8])
        case invalidEventTime(UInt)
        case invalidFormat([UInt8])
        case invalidMetaMessage(UInt8, UInt8, [UInt8])
        case invalidSysExMessage(UInt8, [UInt8])
        case invalidTrackCount(UInt, SMFFormat)
        case missingHeaderChunk
        case notEnoughTrackChunks
        case tooManyHeaderChunks
        case tooManyTrackChunks
        case unexpectedDataByte(UInt8)
        case unknownChannelMessageStatus(UInt8)
        case unknownEventStatus(UInt8)
    }
}

// MARK: - EnhancedError

extension SMFParser.Error: EnhancedError {
    public var category: Category? {
        Category("SMFParser")
    }

    public var message: String {
        switch self {
        case .dataExhaustedPrematurely:
            "Data exhausted prematurely"

        case .emptyTrack:
            "No recognized events found in SMF track chunk"

        case let .invalidChannelMessage(status, data):
            "Invalid MIDI channel message, status: \(status.hex), data: \(data.hex)"

        case let .invalidChunkType(chunkType):
            "Invalid SMF chunk type: ‘\(chunkType)’"

        case let .invalidDivision(bytesValue):
            "Invalid SMF division: \(bytesValue.hex)"

        case let .invalidEventTime(eventTime):
            "Invalid SMF event time: \(eventTime)"

        case let .invalidFormat(bytesValue):
            "Invalid SMF format: \(bytesValue.hex)"

        case let .invalidMetaMessage(status, type, data):
            "Invalid SMF meta-event message, status: \(status.hex), type: \(type.hex), data: \(data.hex)"

        case let .invalidSysExMessage(status, data):
            "Invalid SMF sysex message, status: \(status.hex), data: \(data.hex)"

        case let .invalidTrackCount(trackCount, format):
            "Invalid track count for SMF format \(format.uintValue): \(trackCount)"

        case .missingHeaderChunk:
            "Missing required SMF header chunk"

        case .notEnoughTrackChunks:
            "Not enough SMF track chunks"

        case .tooManyHeaderChunks:
            "Too many SMF header chunks"

        case .tooManyTrackChunks:
            "Too many SMF track chunks"

        case let .unexpectedDataByte(byte):
            "Unexpected MIDI data byte: \(byte.hex)"

        case let .unknownChannelMessageStatus(status):
            "Unknown MIDI channel message status: \(status.hex)"

        case let .unknownEventStatus(status):
            "Unknown SMF event status: \(status.hex)"
        }
    }
}

// MARK: - Sendable

extension SMFParser.Error: Sendable {
}
