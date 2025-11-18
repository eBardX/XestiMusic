// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct GMNNote {

    // MARK: Public Initializers

    public init(pitch: GMNPitch,
                duration: GMNDuration) {
        self.duration = duration
        self.pitch = pitch
    }

    // MARK: Public Instance Properties

    public let duration: GMNDuration
    public let pitch: GMNPitch
}

// MARK: -

extension GMNNote {

    // MARK: Internal Nested Types

    internal typealias ParseResult = (pitch: GMNPitch.ParseResult, duration: GMNDuration.ParseResult?)

    // MARK: Internal Type Methods

    internal static func parseText(_ text: Substring) -> ParseResult? {
        let result = text.splitBeforeFirst([".", "*", "/"])
        let ptext = result.head

        guard let pitch = GMNPitch.parseText(ptext)
        else { return nil }

        guard let dtext = result.tail
        else { return (pitch, nil) }

        return (pitch, GMNDuration.parseText(dtext))
    }
}

// MARK: - Sendable

extension GMNNote: Sendable {
}
