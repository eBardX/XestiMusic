// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFChunkType: StringRepresentable {

    // MARK: Public Type Properties

    public static let header = Self("MThd")
    public static let track  = Self("MTrk")

    public static let invalidMessage = "SMF chunk type must contain exactly 4 ASCII characters"

    // MARK: Public Type Methods

    public static func isValid(_ stringValue: String) -> Bool {
        stringValue.count == 4 && stringValue.allSatisfy { $0.isASCII }
    }

    // MARK: Public Initializers

    public init(_ stringValue: String) {
        self.stringValue = Self.requireValid(stringValue)
    }

    // MARK: Public Instance Properties

    public let stringValue: String
}
