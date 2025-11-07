// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct GMNTablature {

    // MARK: Public Initializers

    public init?(_ text: Substring) {
        guard let (tabString, fret, duration) = Self._parseText(text)
        else { return nil }

        self.duration = duration
        self.fret = fret
        self.tabString = tabString
    }

    // MARK: Public Instance Properties

    public let duration: GMNDuration?
    public let fret: String
    public let tabString: UInt
}

// MARK: -

extension GMNTablature {

    // MARK: Private Type Methods

    private static func _parseText(_ text: Substring) -> (UInt, String, GMNDuration?)? {
        guard text.hasPrefix("s")
        else { return nil }

        let result1 = text.dropFirst().splitBeforeFirst([".", "*", "/"])
        let result2 = result1.head.splitBeforeFirst(":")

        guard let tabString = UInt(result2.head),
              let ftext = result2.tail,
              let fret = _convertFret(ftext)
        else { return nil }

        guard let dtext = result1.tail
        else { return (tabString, fret, nil) }

        return (tabString, fret, GMNDuration(dtext))
    }
}

// MARK: - Sendable

extension GMNTablature: Sendable {
}

// MARK: - Private Functions

private func _convertEscapedCharacter(_ reader: inout SequenceReader<Substring>) -> Character? {
    guard let chr = reader.read()
    else { return nil }

    switch chr {
    case "\"", "\\", "'":
        return chr

    case "n":
        return "\u{0a}"

    default:
        return nil
    }
}

private func _convertFret(_ text: Substring) -> String? {
    var reader = SequenceReader<Substring>(text)

    guard let delimiter = reader.read()
    else { return nil }

    var cvtValue = ""

    while let chr = reader.read() {
        if chr == "\\" {
            guard let cvtChr = _convertEscapedCharacter(&reader)
            else { return nil }

            cvtValue.append(cvtChr)
        } else if chr != delimiter {
            cvtValue.append(chr)
        } else {
            return cvtValue
        }
    }

    return nil
}
