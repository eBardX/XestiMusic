// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

internal struct ABCTokenizer {

    // MARK: Internal Initializers

    internal init(tracing: Verbosity) {
        self.baseTokenizer = Tokenizer(rules: Self.rules,
                                       tracing: tracing)
    }

    // MARK: Private Instance Properties

    private let baseTokenizer: Tokenizer
}

// MARK: -

extension ABCTokenizer {

    // MARK: Internal Nested Types

    internal typealias BaseTokenizer = Tokenizer
    internal typealias Token         = BaseTokenizer.Token

    // MARK: Internal Instance Properties

    internal var tracing: Verbosity {
        baseTokenizer.tracing
    }

    // MARK: Internal Instance Methods

    internal func tokenize(_ input: String) throws -> [Token] {
        try baseTokenizer.tokenize(input: input)
    }

    // MARK: Private Nested Types

    private typealias Condition   = BaseTokenizer.Condition
    private typealias Disposition = BaseTokenizer.Disposition
    private typealias Rule        = BaseTokenizer.Rule
    private typealias Scanner     = BaseTokenizer.Scanner

    // MARK: Private Type Properties

    // <delimiter> = /<whitespace>|<eol>|$/
    //
    // /<whitespace>?(?:<eol>|$)/ (column == 1) => .save(.emptyLine, nil)
    // /%abc-<decUInteger>\.<decUInteger>(?=<delimiter>)/ (column == 1) ==> .save(.fileID, nil)
    // /%%<directiveName>(?=<delimiter>)/ (column == 1) ==> .save(.directiveName, .directive)
    // /%.*(?:<eol>|$)/ (column > 1) => .skip(nil)
    // /<fieldName>/ (column == 1) => .save(.fieldName, .field)
    // /%(???)[^%]*(?:<eol>|$)/ (column == 1) => .skip(nil)

    nonisolated(unsafe) private static let rules: [Rule] = [
        Rule(regex: /%abc/,                             // MUST come before .comment
             validation: _locatedAtFirstColumn,
             disposition: .save(.fileID, nil)),
        Rule(regex: regexDirectiveName,                 // MUST come before .comment
             validation: _locatedAtFirstColumn,
             disposition: .save(.directiveName, nil)),
        Rule(regex: /[ \n\r\t]+/,
             disposition: .skip(nil)),
        Rule(regex: /%.*(?=[\n\r]|$)/,
             disposition: .skip(nil)),
        Rule(/[`]+/, .backquotes),
        Rule(regexBarRepeat, .barRepeat),
        Rule(regexBrokenRhythmLeft, .brokenRhythmLeft),
        Rule(regexBrokenRhythmRight, .brokenRhythmRight),
        Rule(/\{/, .curlyBracketOpen),
        Rule(/\}/, .curlyBracketClose),
        Rule(/-/, .dash),
        Rule(regexDecoration, .decoration),
        Rule(regexDirectiveValue, .directiveValue),
        Rule(regexFieldName, .fieldName),
        Rule(regexFieldValue, .fieldValue),
        Rule(/\//, .forwardSlash),
        Rule(regexNoteLength, .noteLength),
        Rule(/\(/, .roundBracketOpen),
        Rule(/\)/, .roundBracketClose),
        Rule(/\[/, .squareBracketOpen),
        Rule(/]/, .squareBracketClose),
        Rule(regexVersion, .version)
    ]

    // MARK: Private Type Methods

    private static func _locatedAtFirstColumn(_ scanner: inout Scanner,
                                              _ value: Substring,
                                              _ location: Substring.Location,
                                              _ condition: Condition) throws -> Bool {
        location.column == 1
    }
}

// MARK: -

// extension Tokenizer.UserInfoKey {
//    internal static let commentNestingLevel = Self("commentNestingLevel")
// }

// MARK: -

// extension Tokenizer.Condition {
//    internal static let comment     = Self("comment")
//    internal static let parameter   = Self("parameter",
//                                           isInclusive: true)
// }

// MARK: -

extension Tokenizer.Token.Kind {
    internal static let accidental         = Self("accidental")
    internal static let annotation         = Self("annotation")
    internal static let backquotes         = Self("backquotes")
    internal static let barRepeat          = Self("barRepeat")
    internal static let brokenRhythmLeft   = Self("brokenRhythmLeft")
    internal static let brokenRhythmRight  = Self("brokenRhythmRight")
    internal static let chordSymbol        = Self("chordSymbol")
    internal static let curlyBracketClose  = Self("curlyBracketClose")
    internal static let curlyBracketOpen   = Self("curlyBracketOpen")
    internal static let dash               = Self("dash")
    internal static let decoration         = Self("decoration")
    internal static let directiveName      = Self("directiveName")
    internal static let directiveValue     = Self("directiveValue")
    internal static let fieldName          = Self("fieldName")
    internal static let fieldValue         = Self("fieldValue")
    internal static let fileID             = Self("fileID")
    internal static let forwardSlash       = Self("forwardSlash")
    internal static let note               = Self("note")
    internal static let noteLength         = Self("noteLength")
    internal static let octave             = Self("octave")
    internal static let roundBracketClose  = Self("roundBracketClose")
    internal static let roundBracketOpen   = Self("roundBracketOpen")
    internal static let squareBracketClose = Self("squareBracketClose")
    internal static let squareBracketOpen  = Self("squareBracketOpen")
    internal static let version            = Self("version")
}
