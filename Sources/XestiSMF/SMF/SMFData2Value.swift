// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFData2Value: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "SMF (2-byte) data value must be between 0 and 65535 (inclusive)"

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: UInt) -> Bool {
        (0...65_535).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension SMFData2Value: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 2
        else { return nil }

        self.init(uintValue: (UInt(bytesValue[0]) << 8) | UInt(bytesValue[1]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue >> 8),
              let byte1Value = UInt8(exactly: uintValue & 0xff)
        else { return nil }

        return [byte0Value, byte1Value]
    }
}
