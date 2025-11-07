// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension ABCParser {
    public enum Error {
        case invalidDirective(String)
        case invalidField(String)
        case invalidFileID(String)
        case invalidKeySignature(String)
        case invalidPitch(String)
        case invalidRefNumber(String)
        case invalidSymbols(String)
        case invalidTempo(String)
        case invalidTimeSignature(String)
        case invalidUnitNoteLength(String)
    }
}

// MARK: - EnhancedError

extension ABCParser.Error: EnhancedError {
    public var category: Category? {
        Category("ABCParser")
    }

    public var message: String {
        switch self {
        case let .invalidDirective(value):
            "Invalid directive: ‘\(value)’"

        case let .invalidField(value):
            "Invalid field: ‘\(value)’"

        case let .invalidFileID(value):
            "Invalid file identifier: ‘\(value)’"

        case let .invalidKeySignature(value):
            "Invalid key signature: ‘\(value)’"

        case let .invalidPitch(value):
            "Invalid pitch: ‘\(value)’"

        case let .invalidRefNumber(value):
            "Invalid reference number: ‘\(value)’"

        case let .invalidSymbols(value):
            "Invalid music code symbols: ‘\(value)’"

        case let .invalidTempo(value):
            "Invalid tempo: ‘\(value)’"

        case let .invalidTimeSignature(value):
            "Invalid time signature: ‘\(value)’"

        case let .invalidUnitNoteLength(value):
            "Invalid unit note length: ‘\(value)’"
        }
    }
}

// MARK: - Sendable

extension ABCParser.Error: Sendable {
}
