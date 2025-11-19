// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCPitch {

    // MARK: Public Initializers

    public init(letter: String,
                accidental: String,
                octave: String) {
        self.accidental = accidental
        self.letter = letter
        self.octave = octave
    }

    // MARK: Public Instance Properties

    public let accidental: String
    public let letter: String
    public let octave: String
}

// MARK: - Sendable

extension ABCPitch: Sendable {
}
