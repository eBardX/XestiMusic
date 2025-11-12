// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNPitch {

    // MARK: Public Initializers

    public init(_ name: Name,
                _ accidental: Accidental?,
                _ octave: Int) {
        self.accidental = accidental
        self.name = name
        self.octave = octave
    }

    // MARK: Public Instance Properties

    public let accidental: Accidental?
    public let name: Name
    public let octave: Int
}

// MARK: -

extension GMNPitch {

    // MARK: Internal Nested Types

    internal typealias ParseResult = (name: Name, accidental: Accidental?, octave: Int?)

    // MARK: Internal Type Methods

    internal static func parseText(_ text: Substring) -> ParseResult? {
        let result1 = text.splitBeforeFirst(octaveCS)
        let result2 = result1.head.splitBeforeFirst(accidentalCS)

        guard let name = Name(rawValue: String(result2.head))
        else { return nil }

        let accidental: Accidental?
        let octave: Int?

        if let atext = result2.tail {
            accidental = Accidental(rawValue: String(atext))
        } else {
            accidental = nil
        }

        if let otext = result1.tail {
            octave = Int(otext)
        } else {
            octave = nil
        }

        return (name, accidental, octave)
    }

    // MARK: Private Type Properties

    private static let accidentalCS: Set<Character> = ["#", "&"]
    private static let octaveCS: Set<Character>     = ["-", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
}

// MARK: - Sendable

extension GMNPitch: Sendable {
}
