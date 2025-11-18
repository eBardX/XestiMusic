// © 2025 John Gary Pusey (see LICENSE.md)

@preconcurrency import RegexBuilder

extension GMNTokenizer {

    // MARK: Internal Type Properties

    nonisolated(unsafe) internal static let regexFloatingValue = Regex<Substring> {
        Optionally {
            sign
        }
        decUInteger
        "."
        decUInteger
    }

    nonisolated(unsafe) internal static let regexIntegerValue = Regex<Substring> {
        Optionally {
            sign
        }
        decUInteger
    }

    nonisolated(unsafe) internal static let regexNote = Regex<Substring> {
        pitch
        Optionally {
            duration
        }
    }

    nonisolated(unsafe) internal static let regexParameterName = Regex<Substring> {
        name
    }

    nonisolated(unsafe) internal static let regexRest = Regex<Substring> {
        "_"
        Optionally {
            duration
        }
    }

    nonisolated(unsafe) internal static let regexStringValue = Regex<Substring> {
        ChoiceOf {
            doubleQuotedString
            singleQuotedString
        }
    }

    nonisolated(unsafe) internal static let regexTablature = Regex<Substring> {
        tablature
        Optionally {
            duration
        }
    }

    nonisolated(unsafe) internal static let regexTagName = Regex<Substring> {
        ChoiceOf {
            "|"
            Regex<Substring> {
                "\\"
                name
                Optionally {
                    ":"
                    decUInteger
                }
            }
        }
    }

    nonisolated(unsafe) internal static let regexUnit = Regex<Substring> {
        unit
        delimiterLookahead
    }

    nonisolated(unsafe) internal static let regexVariableName = Regex<Substring> {
        "$"
        name
    }
}

// MARK: -

extension GMNTokenizer {

    // MARK: Private Type Properties

    nonisolated(unsafe) private static let accidentals = Regex<Substring> {
        OneOrMore {
            accidental
        }
    }

    nonisolated(unsafe) private static let chromatic = Regex<Substring> {
        ChoiceOf {
            "ais"
            "cis"
            "dis"
            "fis"
            "gis"
        }
    }

    nonisolated(unsafe) private static let decUInteger = Regex<Substring> {
        OneOrMore {
            decDigit
        }
    }

    nonisolated(unsafe) private static let delimiterLookahead = Regex<Substring> {
        Lookahead {
            ChoiceOf {
                delimiter
                /$/
            }
        }
    }

    nonisolated(unsafe) private static let denominator = Regex<Substring> {
        "/"
        decUInteger
    }

    nonisolated(unsafe) private static let dots = Regex<Substring> {
        Repeat(1...3) {
            "."
        }
    }

    nonisolated(unsafe) internal static let doubleQuotedString = Regex<Substring> {
        "\""
        ZeroOrMore {
            ChoiceOf {
                "\\\\"
                Regex<Substring> {
                    "\\"
                    /./
                }
                CharacterClass.anyOf("\\\"").inverted
            }
        }
        "\""
    }

    nonisolated(unsafe) private static let duration = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                ChoiceOf {
                    Regex<Substring> {
                        numerator
                        Optionally {
                            denominator
                        }
                    }
                    Regex<Substring> {
                        denominator
                    }
                }
                Optionally {
                    dots
                }
            }
            Regex<Substring> {
                dots
            }
            Regex<Substring> {
                numerator
                "ms"
            }
        }
    }

    nonisolated(unsafe) private static let fret = Regex<Substring> {
        ":"
        ZeroOrMore {
            ChoiceOf {
                Regex<Substring> {
                    "\\"
                    CharacterClass.anyOf(": ")
                }
                CharacterClass.anyOf(":\\\n").inverted
            }
        }
        ":"
    }

    nonisolated(unsafe) private static let name = Regex<Substring> {
        nameHead
        ZeroOrMore {
            nameTail
        }
    }.ignoresCase()

    nonisolated(unsafe) private static let numerator = Regex<Substring> {
        "*"
        decUInteger
    }

    nonisolated(unsafe) private static let octave = Regex<Substring> {
        Optionally {
            sign
        }
        decUInteger
    }

    nonisolated(unsafe) private static let pitch = Regex<Substring> {
        pitchClass
        Optionally {
            accidentals
        }
        Optionally {
            octave
        }
    }

    nonisolated(unsafe) private static let pitchClass = Regex<Substring> {
        ChoiceOf {
            chromatic
            diatonic
            solfege
            "empty"
        }
        delimiterLookahead
    }

    nonisolated(unsafe) internal static let singleQuotedString = Regex<Substring> {
        "'"
        ZeroOrMore {
            ChoiceOf {
                "\\\\"
                Regex<Substring> {
                    "\\"
                    /./
                }
                CharacterClass.anyOf("\\'").inverted
            }
        }
        "'"
    }

    nonisolated(unsafe) private static let solfege = Regex<Substring> {
        ChoiceOf {
            "do"
            "re"
            "mi"
            "fa"
            "sol"
            "la"
            "si"
            "ti"
        }
    }

    nonisolated(unsafe) private static let tablature = Regex<Substring> {
        "s"
        tabString
        fret
    }

    nonisolated(unsafe) private static let unit = Regex<Substring> {
        ChoiceOf {
            "m"
            "cm"
            "mm"
            "in"
            "pt"
            "pc"
            "hs"
            "rl"
        }
    }

    private static let accidental: CharacterClass = .anyOf("#&")
    private static let delimiter: CharacterClass  = letter.inverted
    private static let decDigit: CharacterClass   = "0"..."9"
    private static let diatonic: CharacterClass   = "a"..."h"
    private static let letter: CharacterClass     = "a"..."z"
    private static let nameHead: CharacterClass   = letter.union(.anyOf("_"))
    private static let nameTail: CharacterClass   = nameHead.union(decDigit)
    private static let sign: CharacterClass       = .anyOf("-+")
    private static let tabString: CharacterClass  = "1"..."6"
}
