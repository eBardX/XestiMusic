//  © 2025 John Gary Pusey (see LICENSE.md)

@preconcurrency import RegexBuilder

extension ABCTokenizer {

    // MARK: Internal Type Properties

    nonisolated(unsafe) internal static let regexBarRepeat = Regex {
        ChoiceOf {
            "::"
            ":|"
            "[|"
            "|:"
            "|]"
            "||"
            "|"
        }
    }

    nonisolated(unsafe) internal static let regexBrokenRhythmLeft = Regex {
        Repeat(1...3) {
            "<"
        }
    }

    nonisolated(unsafe) internal static let regexBrokenRhythmRight = Regex {
        Repeat(1...3) {
            ">"
        }
    }

    nonisolated(unsafe) internal static let regexComment = Regex {
        "%"
        ZeroOrMore {
            /./
        }
        eolLookahead
    }

    nonisolated(unsafe) internal static let regexDecoration = Regex {
        ChoiceOf {
            decorationShorthand
            Regex {
                "!"
                decorationName
                "!"
            }.ignoresCase()
        }
    }

    nonisolated(unsafe) internal static let regexDirectiveName = Regex {
        "%%"
        directiveLetter
    }.ignoresCase()

    nonisolated(unsafe) internal static let regexDirectiveValue = Regex {
        ZeroOrMore {
            /./
        }
        eolLookahead
    }

    nonisolated(unsafe) internal static let regexEndOfLine = Regex {
        eol
    }

    nonisolated(unsafe) internal static let regexFieldName = Regex {
        fieldLetter
        ":"
    }

    nonisolated(unsafe) internal static let regexFieldValue = Regex {
        ZeroOrMore {
            /./
        }
        eolLookahead
    }

    nonisolated(unsafe) internal static let regexNoteLength = Regex {
        ChoiceOf {
            Regex {
                Optionally {
                    decUInteger
                }
                ChoiceOf {
                    Regex {
                        "/"
                        decUInteger
                    }
                    Repeat(1...7) {
                        "/"
                    }
                }
            }
            decUInteger
        }
    }

    nonisolated(unsafe) internal static let regexVersion = Regex {
        decUInteger
        "."
        decUInteger
    }
}

// MARK: -

extension ABCTokenizer {

    // MARK: Private Type Properties

    nonisolated(unsafe) private static let decUInteger = Regex<Substring> {
        OneOrMore {
            decDigit
        }
    }

    nonisolated(unsafe) private static let eol = Regex<Substring> {
        ChoiceOf {
            "\n"
            Regex {
                "\r"
                Optionally {
                    "\n"
                }
            }
        }
    }

    nonisolated(unsafe) private static let eolLookahead = Regex<Substring> {
        Lookahead {
            ChoiceOf {
                eol
                /$/
            }
        }
    }

    private static let alphanum: CharacterClass   = decDigit.union(letter)
    private static let decDigit: CharacterClass   = "0"..."9"
    private static let letter: CharacterClass     = "a"..."z"         // .ignoreCase

    private static let fieldLetter: CharacterClass     = letter.union(.anyOf("+"))      // .ignoreCase
    private static let directiveLetter: CharacterClass = alphanum.union(.anyOf(":-"))   // .ignoreCase

    private static let accidental: CharacterClass          = .anyOf("=^_")
    private static let decorationName: CharacterClass      = alphanum.union(.anyOf("!\"#$%&'()*+,-./;<=>?@\\^_`{}~"))   // .ignoreCase
    private static let decorationShorthand: CharacterClass = .anyOf(".~HLMOPSTuv")
    private static let octave: CharacterClass              = .anyOf("',")
    private static let pitch: CharacterClass               = "a"..."g"                                                  // .ignoreCase
}
