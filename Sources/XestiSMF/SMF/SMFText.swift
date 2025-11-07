// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFText: StringRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "SMF text must not be empty"

    // MARK: Public Initializers

    public init(_ stringValue: String) {
        self.stringValue = Self.requireValid(stringValue)
    }

    // MARK: Public Instance Properties

    public let stringValue: String
}

// MARK: - BytesValueConvertible

extension SMFText: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        let text = String(bytesValue.map { Character(Unicode.Scalar($0)) })

        self.init(stringValue: text)
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        Array(stringValue.utf8)
    }
}
