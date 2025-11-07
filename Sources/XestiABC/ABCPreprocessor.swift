// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

internal struct ABCPreprocessor {

    // MARK: Internal Initializers

    internal init(_ data: Data) {
        self.cookedLine = ""
        self.rawLineReader = SequenceReader("")
        self.dataReader = SequenceReader(data)
    }

    // MARK: Private Instance Properties

    private var cookedLine: String
    private var dataReader: SequenceReader<Data>
    private var rawLineReader: SequenceReader<String>
}

// MARK: -

extension ABCPreprocessor {

    // MARK: Internal Instance Methods

    internal mutating func nextLine() throws -> String? {
        while let rawLine = try _nextRawLine() {
            guard _configureOven(with: rawLine),
                  let line = _bakeRawLine()
            else { continue }

            return line
        }

        return nil
    }

    // MARK: Private Instance Methods

    //
    // Note: nil return value means “ignore line completely”
    //
    private mutating func _bakeRawLine() -> String? {
        var commentSeen = false

    loop:
        while let chr = rawLineReader.read() {
            switch chr {
            case "\\":
                _handleBackslash()

            case "&":
                _handleAmpersand()

            case "%":
                commentSeen = true
                break loop

            default:
                cookedLine.append(chr)
            }
        }

        cookedLine = cookedLine.normalizedABCWhitespace()

        guard !cookedLine.isEmpty || !commentSeen
        else { return nil }

        return cookedLine
    }

    private mutating func _configureOven(with rawLine: String) -> Bool {
        cookedLine = ""
        rawLineReader = SequenceReader(rawLine)

        guard let skipCount = _knownPrefixCount(rawLine)
        else { return true }

        for _ in 0..<skipCount {
            guard let chr = rawLineReader.read()
            else { return false }

            cookedLine.append(chr)
        }

        return true
    }

    private mutating func _handleAmpersand() {
        var entity = "&"

        while let chr = rawLineReader.peek() {
            guard chr.isABCAlphanumeric || chr == ";"
            else { break }

            entity.append(chr)

            rawLineReader.skip()

            if chr == ";" {
                break
            }
        }

        if let replacement = Self.namedHTMLEntities[entity] {
            cookedLine.append(replacement)
        } else {
            cookedLine.append(entity)
        }
    }

    private mutating func _handleBackslash() {
        guard let chr = rawLineReader.read()
        else { cookedLine.append("\\"); return }

        switch chr {
        case "'", "\"", "/", "`", "^", "~", "a", "A", "c", "d", "D", "H", "o", "O", "s", "t", "T", /*"u",*/ "v":
            _handleMnemonic(chr)

        case "\\", "&", "%":
            cookedLine.append(chr)

        case "u":
            _handleMnemonicOrUnicode(chr)

        case "U":
            _handleUnicode(chr)

        default:
            cookedLine.append("\\")
            cookedLine.append(chr)
        }
    }

    private mutating func _handleMnemonic(_ chr: Character) {
        var mnemonic = "\\" + String(chr)

        while let chr = rawLineReader.peek(), mnemonic.count < 3 {
            guard chr.isABCAlphanumeric
            else { break }

            mnemonic.append(chr)

            rawLineReader.skip()
        }

        if let replacement = Self.mnemonics[mnemonic] {
            cookedLine.append(replacement)
        } else {
            cookedLine.append(mnemonic)
        }
    }

    private mutating func _handleMnemonicOrUnicode(_ chr: Character) {
        let maxCount = chr == "U" ? 8 : 4
        let prefix = "\\" + String(chr)

        var mnemonic = "\\" + String(chr)
        var hexDigits = ""

        while let chr = rawLineReader.peek(), mnemonic.count < 3, hexDigits.count < maxCount {
            if chr.isABCAlphanumeric {
                mnemonic.append(chr)
            } else if chr.isABCHexDigit {
                hexDigits.append(chr)
            } else {
                break
            }

            rawLineReader.skip()
        }

        if let replacement = Self.mnemonics[mnemonic] {
            cookedLine.append(replacement)
        } else if hexDigits.count == maxCount,
                  let value = Int(hexDigits),
                  let ucs = Unicode.Scalar(value) {
            cookedLine.append(Character(ucs))
        } else if mnemonic.count > (prefix + hexDigits).count {
            cookedLine.append(mnemonic)
        } else {
            cookedLine.append(prefix + hexDigits)
        }
    }

    private mutating func _handleUnicode(_ chr: Character) {
        let maxCount = chr == "U" ? 8 : 4
        let prefix = "\\" + String(chr)

        var hexDigits = ""

        while let chr = rawLineReader.peek(), hexDigits.count < maxCount {
            guard chr.isABCHexDigit
            else { break }

            hexDigits.append(chr)

            rawLineReader.skip()
        }

        if hexDigits.count == maxCount,
           let value = Int(hexDigits),
           let ucs = Unicode.Scalar(value) {
            cookedLine.append(Character(ucs))
        } else {
            cookedLine.append(prefix + hexDigits)
        }
    }

    private func _knownPrefixCount(_ line: String) -> Int? {
        for prefix in Self.knownPrefixes where line.hasPrefix(prefix) {
            return prefix.count
        }

        return nil
    }

    //
    // Note: nil return value means “no more data available”
    //
    private mutating func _nextRawLine() throws -> String? {
        var bytes: [UInt8] = []
        var eolSeen = false

        while !eolSeen, let byte = dataReader.read() {
            switch byte {
            case 0x0a:
                eolSeen = true

            case 0x0d:
                if dataReader.peek() == 0x0a {
                    dataReader.skip()
                }

                eolSeen = true

            default:
                bytes.append(byte)
            }
        }

        guard eolSeen || !bytes.isEmpty
        else { return nil }

        guard let rawLine = String(data: Data(bytes),
                                   encoding: .utf8)
        else { throw Error.dataConversionFailed }

        return rawLine
    }
}
