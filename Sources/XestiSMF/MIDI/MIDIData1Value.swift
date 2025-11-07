// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct MIDIData1Value: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "MIDI (1-byte) data value must be between 0 and 127 (inclusive)"

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: UInt) -> Bool {
        (0...127).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension MIDIData1Value: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 1
        else { return nil }

        self.init(uintValue: UInt(bytesValue[0]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue)
        else { return nil }

        return [byte0Value]
    }
}
