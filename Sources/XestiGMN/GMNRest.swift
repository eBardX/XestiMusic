// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct GMNRest {

    // MARK: Public Initializers

    public init(_ duration: GMNDuration) {
        self.duration = duration
    }

    // MARK: Public Instance Properties

    public let duration: GMNDuration
}

// MARK: -

extension GMNRest {

    // MARK: Internal Nested Types

    internal typealias ParseResult = (String, duration: GMNDuration.ParseResult?)

    // MARK: Internal Type Methods

    internal static func parseText(_ text: Substring) -> ParseResult? {
        let result = text.splitBeforeFirst([".", "*", "/"])
        let rtext = result.head

        guard let rest = (rtext == "_" ? String(rtext) : nil)
        else { return nil }

        guard let dtext = result.tail
        else { return (rest, nil) }

        return (rest, GMNDuration.parseText(dtext))
    }
}

// MARK: - Sendable

extension GMNRest: Sendable {
}
