// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension ABCSymbol {
    internal struct Parser {

        // MARK: Internal Initializers

        internal init(_ value: String) {
            self.reader = SequenceReader(value)
            self.symbols = []
            self.value = value
        }

        // MARK: Internal Instance Methods

        internal mutating func parse() throws -> [ABCSymbol] {
            while let chr = reader.peek() {
                var symbol: ABCSymbol?

                switch chr {
                case "_", "^", "=", "a"..."g", "A"..."G":
                    symbol = try _parseNote()

                case ";", "?", "@", "*", "#":
                    reader.skip()               // ignore for now…

                case ":", "|":
                    symbol = try _parseBarLine()

                case "!":
                    symbol = try _parseLongDecoration()

                case "~", "h"..."w", "H"..."W":
                    symbol = try .shortDecoration(_scanOneCharString())

                case ".", "\"", "(", "[":
                    symbol = try _parseAmbiguous()

                case "{":
                    symbol = try _parseTuplet()

                case "<", ">":
                    symbol = try _parseBrokenRhythm()

                case "x", "X", "z", "Z":
                    symbol = try _parseRest()

                case "y":
                    symbol = try .spacer(_scanOneCharString())

                default:
                    guard chr.isWhitespace
                    else { throw ABCParser.Error.invalidSymbols(value) }

                    reader.skip()
                }

                if let symbol {
                    symbols.append(symbol)
                }
            }

            return symbols
        }

        // MARK: Private Instance Properties

        private let value: String

        private var reader: SequenceReader<String>
        private var symbols: [ABCSymbol]
    }
}

// MARK: -

extension ABCSymbol.Parser {

    // MARK: Private Instance Methods

    private mutating func _parseAmbiguous() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseAnnotation() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseBarLine() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseBrokenRhythm() throws -> ABCSymbol {
        var buffer = ""

        while let chr = reader.peek() {
            guard chr.isABCBrokenRhythmSymbol
            else { break }

            reader.skip()

            buffer.append(chr)
        }

        return .brokenRhythm(buffer)
    }

    private mutating func _parseChord() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseChordSymbol() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseGraceNotes() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseLongDecoration() throws -> ABCSymbol {
        guard reader.read() == "!"
        else { throw ABCParser.Error.invalidSymbols(value) }

        var buffer = ""

        while let chr = reader.read() {
            guard chr != "!"
            else { break }

            guard chr.isABCDecorationNamePart
            else { throw ABCParser.Error.invalidSymbols(value) }

            buffer.append(chr)
        }

        return .longDecoration(buffer)
    }

    private mutating func _parseNote() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseRepeat() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseRest() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseSlur() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseTuplet() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _parseVariantEnding() throws -> ABCSymbol {
        throw ABCParser.Error.invalidSymbols(value)
    }

    private mutating func _scanOneCharString() throws -> String {
        guard let chr = reader.read()
        else { throw ABCParser.Error.invalidSymbols(value) }

        return String(chr)
    }
}
