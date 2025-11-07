// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCKeySignature {

    // MARK: Public Nested Types

    public typealias Accidental = ABCPitch

    // MARK: Public Type Methods

    public static func parse(_ value: String) throws -> Self? {
        guard !value.isEmpty,
              value.lowercased() != "none"
        else { return nil }

        var chunker = value.split(separator: " ").makeIterator()

        guard let chunk = chunker.next(),
              let tonic = Tonic(rawValue: String(chunk))
        else { throw ABCParser.Error.invalidKeySignature(value) }

        var accidentals: [Accidental] = []
        var mode: Mode = .major

        if let chunk = chunker.next() {
            guard let tmpMode = Mode(String(chunk))
            else { throw ABCParser.Error.invalidKeySignature(value) }

            mode = tmpMode
        }

        while let chunk = chunker.next() {
            guard let accidental = try? ABCPitch.parse(String(chunk))
            else { throw ABCParser.Error.invalidKeySignature(value) }

            accidentals.append(accidental)
        }

        return Self(tonic,
                    mode,
                    accidentals)
    }

    // MARK: Public Instance Properties

    public let accidentals: [Accidental]
    public let mode: Mode
    public let tonic: Tonic

    // MARK: Private Initializers

    private init(_ tonic: Tonic,
                 _ mode: Mode,
                 _ accidentals: [Accidental]) {
        self.accidentals = accidentals
        self.mode = mode
        self.tonic = tonic
    }
}

// MARK: - Sendable

extension ABCKeySignature: Sendable {
}
