// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct MIDIData2Value: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "MIDI (2-byte) data value must be between 0 and 16383 (inclusive)"

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: Int) -> Bool {
        (0...16_383).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension MIDIData2Value: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 2
        else { return nil }

        self.init(uintValue: (UInt(bytesValue[1]) << 7) | UInt(bytesValue[0]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue & 0x7f),
              let byte1Value = UInt8(exactly: uintValue >> 7)
        else { return nil }

        return [byte0Value, byte1Value]
    }
}
