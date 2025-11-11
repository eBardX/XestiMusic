// © 2025 John Gary Pusey (see LICENSE.md)

public struct SMFTimeSignature {

    // MARK: Public Initializers

    public init?(_ numerator: UInt,
                 _ denominator: UInt,
                 _ clockRate: UInt,
                 _ beatRate: UInt) {
        guard (1...255).contains(numerator),
              (2...255).contains(denominator),
              (1...255).contains(clockRate),
              (1...255).contains(beatRate)
        else { return nil }

        self.beatRate = beatRate
        self.clockRate = clockRate
        self.denominator = denominator
        self.numerator = numerator
    }

    // MARK: Public Instance Properties

    public let beatRate: UInt       // notated 32nd-notes per MIDI quarter note (usually 8)
    public let clockRate: UInt      // MIDI clocks per metronome click
    public let denominator: UInt    // 1/(2^den) (e.g. 2 == 1/4, 3 == 1/8)
    public let numerator: UInt
}

// MARK: - BytesValueConvertible

extension SMFTimeSignature: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 4
        else { return nil }

        self.init(UInt(bytesValue[0]),
                  UInt(bytesValue[1]),
                  UInt(bytesValue[2]),
                  UInt(bytesValue[3]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: numerator),
              let byte1Value = UInt8(exactly: denominator),
              let byte2Value = UInt8(exactly: clockRate),
              let byte3Value = UInt8(exactly: beatRate)
        else { return nil }

        return [byte0Value, byte1Value, byte2Value, byte3Value]
    }
}

// MARK: - Sendable

extension SMFTimeSignature: Sendable {
}
