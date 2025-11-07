// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNPitch {

    // MARK: Public Initializers

    public init(_ name: String,
                _ accidental: String?,
                _ octave: Int?) {
        self.accidental = accidental
        self.name = name
        self.octave = octave
    }

    public init?(_ text: Substring) {
        guard let (name, accidental, octave) = Self._parseText(text)
        else { return nil }

        self.init(name, accidental, octave)
    }

    // MARK: Public Instance Properties

    public let accidental: String?
    public let name: String
    public let octave: Int?
}

// MARK: -

extension GMNPitch {

    // MARK: Private Type Properties

    private static let accidentalCS: Set<Character> = ["#", "&"]
    private static let octaveCS: Set<Character>     = ["-", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    // MARK: Private Type Methods

    private static func _parseText(_ text: Substring) -> (String, String?, Int?)? {
        let result1 = text.splitBeforeFirst(octaveCS)
        let result2 = result1.head.splitBeforeFirst(accidentalCS)

        let name = String(result2.head)
        let accidental: String?
        let octave: Int?

        if let atext = result2.tail {
            accidental = String(atext)
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
}

// MARK: - Sendable

extension GMNPitch: Sendable {
}
