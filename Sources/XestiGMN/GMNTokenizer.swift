// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

internal struct GMNTokenizer {

    // MARK: Internal Initializers

    internal init(tracing: Verbosity) {
        self.baseTokenizer = Tokenizer(rules: Self.rules,
                                       tracing: tracing)
    }

    // MARK: Private Instance Properties

    private let baseTokenizer: Tokenizer
}

// MARK: -

extension GMNTokenizer {

    // MARK: Internal Nested Types

    internal typealias BaseTokenizer = XestiTools.Tokenizer
    internal typealias Condition     = BaseTokenizer.Condition
    internal typealias Disposition   = BaseTokenizer.Disposition
    internal typealias Rule          = BaseTokenizer.Rule
    internal typealias Scanner       = BaseTokenizer.Scanner
    internal typealias Token         = BaseTokenizer.Token

    // MARK: Internal Instance Properties

    internal var tracing: Verbosity {
        baseTokenizer.tracing
    }

    // MARK: Internal Instance Methods

    internal func tokenize(_ input: String) throws -> [Token] {
        try baseTokenizer.tokenize(input: input)
    }

    // MARK: Private Type Properties

    nonisolated(unsafe) private static let rules: [Rule] = [Rule(regexUnit, .unit),                        // MUST come before .parameterName
                                                            Rule(regex: /[ \n\r\t]+/,
                                                                 disposition: .skip(nil)),
                                                            Rule(regex: /%.*(?=[\n\r]|$)/,
                                                                 disposition: .skip(nil)),
                                                            Rule(regex: /\(\*/,
                                                                 conditions: [.comment, .initial],
                                                                 disposition: .skip(.comment),
                                                                 action: _beginCommentAction),
                                                            Rule(regex: /.|[\n\r]+/,
                                                                 conditions: [.comment],
                                                                 disposition: .skip(nil)),
                                                            Rule(regex: /\*\)/,
                                                                 conditions: [.comment],
                                                                 disposition: .skip(nil),
                                                                 action: _endCommentAction),
                                                            Rule(regex: /</,
                                                                 disposition: .save(.angleBracketOpen, .parameter)),
                                                            Rule(regex: regexParameterName,                // MUST come before .note
                                                                 conditions: [.parameter],
                                                                 disposition: .save(.parameterName, nil)),
                                                            Rule(regex: />/,
                                                                 conditions: [.parameter],
                                                                 disposition: .save(.angleBracketClose, .initial)),
                                                            Rule(/\{/, .curlyBracketOpen),
                                                            Rule(/\}/, .curlyBracketClose),
                                                            Rule(/,/, .comma),
                                                            Rule(/\[/, .squareBracketOpen),
                                                            Rule(/]/, .squareBracketClose),
                                                            Rule(/\(/, .roundBracketOpen),
                                                            Rule(/\)/, .roundBracketClose),
                                                            Rule(/=/, .equalSign),
                                                            Rule(/;/, .semicolon),
                                                            Rule(regexFloatingValue, .floatingValue),
                                                            Rule(regexIntegerValue, .integerValue),
                                                            Rule(regexNote, .note),
                                                            Rule(regexRest, .rest),
                                                            Rule(regexStringValue, .stringValue),
                                                            Rule(regexTablature, .tablature),
                                                            Rule(regexTagName, .tagName),
                                                            Rule(regexVariableName, .variableName)]

    // MARK: Private Type Methods

    private static func _beginCommentAction(_ scanner: inout Scanner,
                                            _ value: Substring,
                                            _ condition: Condition) throws -> Disposition? {
        if condition == .initial {
            scanner[.commentNestingLevel] = 1
        } else if var level = scanner[.commentNestingLevel] as? Int {
            level += 1

            scanner[.commentNestingLevel] = level
        }

        return nil
    }

    private static func _endCommentAction(_ scanner: inout Scanner,
                                          _ value: Substring,
                                          _ condition: Condition) throws -> Disposition? {
        if var level = scanner[.commentNestingLevel] as? Int {
            level -= 1

            scanner[.commentNestingLevel] = level

            if level == 0 {
                return .skip(.initial)
            }
        }

        return nil
    }
}

// MARK: -

extension Tokenizer.UserInfoKey {
    internal static let commentNestingLevel = Self("commentNestingLevel")
}

// MARK: -

extension Tokenizer.Condition {
    internal static let comment     = Self("comment")
    internal static let parameter   = Self("parameter",
                                           isInclusive: true)
}

// MARK: -

extension Tokenizer.Token.Kind {
    internal static let angleBracketClose  = Self("angleBracketClose")
    internal static let angleBracketOpen   = Self("angleBracketOpen")
    internal static let comma              = Self("comma")
    internal static let curlyBracketClose  = Self("curlyBracketClose")
    internal static let curlyBracketOpen   = Self("curlyBracketOpen")
    internal static let equalSign          = Self("equalSign")
    internal static let floatingValue      = Self("floatingValue")
    internal static let integerValue       = Self("integerValue")
    internal static let note               = Self("note")
    internal static let parameterName      = Self("parameterName")
    internal static let rest               = Self("rest")
    internal static let roundBracketClose  = Self("roundBracketClose")
    internal static let roundBracketOpen   = Self("roundBracketOpen")
    internal static let semicolon          = Self("semicolon")
    internal static let squareBracketClose = Self("squareBracketClose")
    internal static let squareBracketOpen  = Self("squareBracketOpen")
    internal static let stringValue        = Self("stringValue")
    internal static let tablature          = Self("tablature")
    internal static let tagName            = Self("tagName")
    internal static let unit               = Self("unit")
    internal static let variableName       = Self("variableName")
}
