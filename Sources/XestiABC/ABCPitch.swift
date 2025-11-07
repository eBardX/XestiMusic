// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCPitch {

    // MARK: Public Type Methods

    public static func parse(_ value: String) throws -> Self {
        guard let match = value.wholeMatch(of: /((?:__?|\^\^?|=)?)([A-Ga-g])([',]*)/)
        else { throw ABCParser.Error.invalidPitch(value) }

        return Self(String(match.2),
                    String(match.1),
                    String(match.3))
    }

    // MARK: Public Instance Properties

    public let accidental: String
    public let letter: String
    public let octave: String

    // MARK: Private Initializers

    private init(_ letter: String,
                 _ accidental: String,
                 _ octave: String) {
        self.accidental = accidental
        self.letter = letter
        self.octave = octave
    }
}

// MARK: - Sendable

extension ABCPitch: Sendable {
}
