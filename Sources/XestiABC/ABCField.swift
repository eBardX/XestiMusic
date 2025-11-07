// © 2025 John Gary Pusey (see LICENSE.md)

public enum ABCField {
    case area(String)                   // A
    case book(String)                   // B
    case composer(String)               // C
    case continuation(String)           // +
    case discography(String)            // D
    case fileURL(String)                // F
    case group(String)                  // G
    case history(String)                // H
    case instruction(String)            // I
    case key(ABCKeySignature?)          // K
    case macro(String)                  // m
    case meter(ABCTimeSignature?)       // M
    case notes(String)                  // N
    case origin(String)                 // O
    case other(Character, String)       // letters not defined in 2.1 standard
    case parts(String)                  // P
    case referenceNumber(ABCRefNumber)  // X
    case remark(String)                 // r
    case rhythm(String)                 // R
    case source(String)                 // S
    case symbolLine(String)             // s
    case tempo(ABCTempo)                // Q
    case transcription(String)          // Z
    case tuneTitle(String)              // T
    case unitNoteLength(ABCFraction)    // L
    case userDefined(String)            // U
    case voice(String)                  // V
    case words1(String)                 // W
    case words2(String)                 // w
}

// MARK: -

extension ABCField {

    // MARK: Public Type Methods

    public static func canParse(_ value: String) -> Bool {
        guard let letter = value.first,
              letter.isABCLetter || letter == "+"
        else { return false }

        return value.dropFirst().first == ":"
    }

    public static func parse(_ value: String) throws -> Self {
        guard let (letter, content) = _splitPossibleField(value)
        else { throw ABCParser.Error.invalidField(value) }

        switch letter {
        case "+":
            return .continuation(content)

        case "A":
            return .area(content)

        case "B":
            return .book(content)

        case "C":
            return .composer(content)

        case "D":
            return .discography(content)

        case "F":
            return .fileURL(content)

        case "G":
            return .group(content)

        case "H":
            return .history(content)

        case "I":
            return .instruction(content)

        case "K":
            return try .key(.parse(content))

        case "L":
            guard let fraction = ABCFraction(content)
            else { throw ABCParser.Error.invalidUnitNoteLength(content) }

            return .unitNoteLength(fraction)

        case "m":
            return .macro(content)

        case "M":
            return try .meter(.parse(content))

        case "N":
            return .notes(content)

        case "O":
            return .origin(content)

        case "P":
            return .parts(content)

        case "Q":
            return try .tempo(.parse(content))

        case "r":
            return .remark(content)

        case "R":
            return .rhythm(content)

        case "S":
            return .source(content)

        case "s":
            return .symbolLine(content)

        case "T":
            return .tuneTitle(content)

        case "U":
            return .userDefined(content)

        case "V":
            return .voice(content)

        case "W":
            return .words1(content)

        case "w":
            return .words2(content)

        case "X":
            return try .referenceNumber(.parse(content))

        case "Z":
            return .transcription(content)

        case "a"..."z", "A"..."Z":
            return .other(letter, content)

        default:
            throw ABCParser.Error.invalidField(value)
        }
    }

    // MARK: Public Instance Properties

    //    public var isInlineable: Bool {
    //        switch self {
    //        case .instruction,
    //                .key,
    //                .macro,
    //                .meter,
    //                .notes,
    //                .other,
    //                .parts,
    //                .remark,
    //                .rhythm,
    //                .tempo,
    //                .unitNoteLength,
    //                .userDefined,
    //                .voice:
    //            true
    //
    //        default:
    //            false
    //        }
    //    }

    //    public var isValidInFileHeader: Bool {
    //        switch self {
    //        case .area,
    //                .book,
    //                .composer,
    //                .discography,
    //                .fileURL,
    //                .group,
    //                .history,
    //                .instruction,
    //                .macro,
    //                .meter,
    //                .notes,
    //                .origin,
    //                .other,
    //                .remark,
    //                .rhythm,
    //                .source,
    //                .transcription,
    //                .unitNoteLength,
    //                .userDefined:
    //            true
    //
    //        default:
    //            false
    //        }
    //    }

    //    public var isValidInTuneBody: Bool {
    //        switch self {
    //        case .instruction,
    //                .key,
    //                .macro,
    //                .meter,
    //                .notes,
    //                .other,
    //                .parts,
    //                .remark,
    //                .rhythm,
    //                .symbolLine,
    //                .tempo,
    //                .tuneTitle,
    //                .unitNoteLength,
    //                .userDefined,
    //                .voice,
    //                .words1,
    //                .words2:
    //            true
    //
    //        default:
    //            false
    //        }
    //    }

    //    public var isValidInTuneHeader: Bool {
    //        switch self {
    //        case .area,
    //                .book,
    //                .composer,
    //                .discography,
    //                .fileURL,
    //                .group,
    //                .history,
    //                .instruction,
    //                .key,
    //                .macro,
    //                .meter,
    //                .notes,
    //                .origin,
    //                .other,
    //                .parts,
    //                .referenceNumber,
    //                .remark,
    //                .rhythm,
    //                .source,
    //                .tempo,
    //                .transcription,
    //                .tuneTitle,
    //                .unitNoteLength,
    //                .userDefined,
    //                .voice,
    //                .words1:
    //            true
    //
    //        default:
    //            false
    //        }
    //    }

    // MARK: Private Type Methods

    private static func _splitPossibleField(_ value: String) -> (Character, String)? {
        let tokens = value.split(separator: ":",
                                 maxSplits: 1,
                                 omittingEmptySubsequences: false)

        guard tokens.count == 2,
              tokens[0].count == 1,
              let letter = tokens[0].first
        else { return nil }

        let content = String(tokens[1]).normalizedABCWhitespace()

        return (letter, content)
    }
}

// MARK: - Sendable

extension ABCField: Sendable {
}
