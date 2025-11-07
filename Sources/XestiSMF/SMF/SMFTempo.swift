// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFTempo: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "SMF tempo must be between 0 and 16777215 (inclusive)"

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: UInt) -> Bool {
        (0...16_777_215).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension SMFTempo: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 3
        else { return nil }

        self.init(uintValue: (UInt(bytesValue[0]) << 16) | (UInt(bytesValue[1]) << 8) | UInt(bytesValue[2]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue >> 16),
              let byte1Value = UInt8(exactly: (uintValue >> 8) & 0xff),
              let byte2Value = UInt8(exactly: uintValue & 0xff)
        else { return nil }

        return [byte0Value, byte1Value, byte2Value]
    }
}
