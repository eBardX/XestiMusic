// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFEventTime: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "SMF time must be between 0 and 0x7fffffff (inclusive)"

    public static let zero = Self(0)

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: Int) -> Bool {
        (0...0x7fffffff).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}
