// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension SMFFormatter {
    public enum Error {
        case invalidByte(UInt)
        case invalidChunkLength(UInt)
        case invalidChunkType(SMFChunkType)
        case invalidDivision(SMFDivision)
        case invalidEvent(SMFEvent)
        case invalidFormat(SMFFormat)
        case invalidTrackCount(UInt)
        case invalidVarlen(UInt)
        case invalidWord(UInt)
    }
}

// MARK: - EnhancedError

extension SMFFormatter.Error: EnhancedError {
    public var category: Category? {
        Category("SMFFormatter")
    }

    public var message: String {
        switch self {
        case let .invalidByte(value):
            "Invalid byte: \(value)"

        case let .invalidChunkLength(value):
            "Invalid chunk length: \(value)"

        case let .invalidChunkType(value):
            "Invalid chunk type: ‘\(value)’"

        case let .invalidDivision(division):
            "Invalid division: \(division)"

        case let .invalidEvent(event):
            "Invalid event: \(event)"

        case let .invalidFormat(format):
            "Invalid format: \(format)"

        case let .invalidTrackCount(value):
            "Invalid track count: \(value)"

        case let .invalidVarlen(value):
            "Invalid varlen: \(value)"

        case let .invalidWord(value):
            "Invalid word: \(value)"
        }
    }
}

// MARK: - Sendable

extension SMFFormatter.Error: Sendable {
}
