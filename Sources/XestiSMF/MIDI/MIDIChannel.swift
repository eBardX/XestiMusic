// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct MIDIChannel: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "MIDI channel must be between 1 and 16 (inclusive)"

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: UInt) -> Bool {
        (1...16).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension MIDIChannel: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 1
        else { return nil }

        self.init(uintValue: UInt(bytesValue[0]) + 1)
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue - 1)
        else { return nil }

        return [byte0Value]
    }
}
