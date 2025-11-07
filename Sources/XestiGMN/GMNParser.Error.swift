// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension GMNParser {
    public enum Error {
        case dataConversionFailed
        case endOfInput
        case invalidChordSegment([GMNSymbol])
        case invalidNote(Substring)
        case invalidNumber(Substring)
        case invalidRest(Substring)
        case invalidString(Substring)
        case invalidTablature(Substring)
        case missingTagName
        case missingVariableValue
        case nestedChord
        case trailingGarbage
    }
}

// MARK: - EnhancedError

extension GMNParser.Error: EnhancedError {
    public var category: Category? {
        Category("GMNParser")
    }

    public var message: String {
        switch self {
        case .dataConversionFailed:
            "Failed to convert UTF-8 data to string"

        case .endOfInput:
            "End of input reached prematurely"

        case let .invalidChordSegment(symbols):
            "Invalid chord segment: \(symbols)"

        case let .invalidNote(value):
            "Invalid note: ‘\(value)’"

        case let .invalidNumber(value):
            "Invalid number: ‘\(value)’"

        case let .invalidRest(value):
            "Invalid rest: ‘\(value)’"

        case let .invalidString(value):
            "Invalid string: ‘\(value)’"

        case let .invalidTablature(value):
            "Invalid tablature: ‘\(value)’"

        case .missingTagName:
            "Missing tag name"

        case .missingVariableValue:
            "Missing variable value"

        case .nestedChord:
            "Nested chords are disallowed"

        case .trailingGarbage:
            "Input contains trailing garbage"
        }
    }
}

// MARK: - Sendable

extension GMNParser.Error: Sendable {
}
