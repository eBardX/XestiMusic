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
    case key(ABCKeySignature)           // K
    case macro(String)                  // m
    case meter(ABCTimeSignature)        // M
    case notes(String)                  // N
    case origin(String)                 // O
    case other(Character, String)       // letter not defined in standard
    case parts(String)                  // P
    case refNumber(ABCRefNumber)        // X
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
    //                .refNumber,
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
}

// MARK: - Sendable

extension ABCField: Sendable {
}
