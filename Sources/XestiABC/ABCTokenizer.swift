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

    nonisolated(unsafe) private static let rules: [Rule] = [
        Rule(/%abc/, .fileID),                      // MUST come before .comment
        Rule(regexDirectiveName, .directiveName),   // MUST come before .comment
        Rule(/[`]+/, .backquotes),
        Rule(regexBarRepeat, .barRepeat),
        Rule(regexBrokenRhythmLeft, .brokenRhythmLeft),
        Rule(regexBrokenRhythmRight, .brokenRhythmRight),
        Rule(regexComment, .comment),
        Rule(/\{/, .curlyBracketOpen),
        Rule(/\}/, .curlyBracketClose),
        Rule(/-/, .dash),
        Rule(regexDecoration, .decoration),
        Rule(regexDirectiveValue, .directiveValue),
        Rule(regexEndOfLine, .endOfLine),
        Rule(regexFieldName, .fieldName),
        Rule(regexFieldValue, .fieldValue),
        Rule(/\//, .forwardSlash),
        Rule(regexNoteLength, .noteLength),
        Rule(/\(/, .roundBracketOpen),
        Rule(/\)/, .roundBracketClose),
        Rule(/\[/, .squareBracketOpen),
        Rule(/]/, .squareBracketClose),
        Rule(regexVersion, .version),
        Rule(/[ \t]+/, .whitespace)

        // Rule(regex: /[ \n\r\t]+/,
        //      disposition: .skip(nil)),
        // Rule(regex: /%.*(?=[\n\r]|$)/,
        //      disposition: .skip(nil)),
        // Rule(regex: /\(\*/,
        //     conditions: [.comment, .initial],
        //     disposition: .skip(.comment),
        //     action: _beginCommentAction),
        // Rule(regex: /.|[\n\r]+/,
        //     conditions: [.comment],
        //     disposition: .skip(nil)),
        // Rule(regex: /\*\)/,
        //     conditions: [.comment],
        //     disposition: .skip(nil),
        //     action: _endCommentAction),
        // Rule(regex: /</,
        //     disposition: .save(.angleBracketOpen, .parameter)),
        // Rule(regex: regexParameterName,                // MUST come before .note
        //     conditions: [.parameter],
        //     disposition: .save(.parameterName, nil)),
        // Rule(regex: />/,
        //     conditions: [.parameter],
        //     disposition: .save(.angleBracketClose, .initial)),
        // Rule(/,/, .comma),
        // Rule(/=/, .equalSign),
        // Rule(/;/, .semicolon)
    ]

    // MARK: Private Type Methods
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
    internal static let comment            = Self("comment")
    internal static let curlyBracketClose  = Self("curlyBracketClose")
    internal static let curlyBracketOpen   = Self("curlyBracketOpen")
    internal static let dash               = Self("dash")
    internal static let decoration         = Self("decoration")
    internal static let directiveName      = Self("directiveName")
    internal static let directiveValue     = Self("directiveValue")
    internal static let endOfLine          = Self("endOfLine")
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
    internal static let whitespace         = Self("whitespace")
}
