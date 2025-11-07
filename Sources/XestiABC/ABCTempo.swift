// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTempo {

    // MARK: Public Type Methods

    public static func parse(_ value: String) throws -> Self {
        guard let match = value.wholeMatch(of: /.*(\d+\/\d+)\s*=\s*(\d+).*/),
              let beatLength = ABCFraction(String(match.1)),
              let beatsPerMinute = UInt(match.2),
              beatsPerMinute > 0
        else { throw ABCParser.Error.invalidTempo(value) }

        return Self(beatLength,
                    beatsPerMinute)
    }

    // MARK: Public Instance Properties

    public let beatLength: ABCFraction
    public let beatsPerMinute: UInt

    // MARK: Private Initializers

    private init(_ beatLength: ABCFraction,
                 _ beatsPerMinute: UInt) {
        self.beatLength = beatLength
        self.beatsPerMinute = beatsPerMinute
    }
}

// MARK: - Sendable

extension ABCTempo: Sendable {
}
