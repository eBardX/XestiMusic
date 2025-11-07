// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct GMNRest {

    // MARK: Public Initializers

    public init?(_ text: Substring) {
        guard let (_, duration) = Self._parseText(text)
        else { return nil }

        self.duration = duration
    }

    // MARK: Public Instance Properties

    public let duration: GMNDuration?
}

// MARK: -

extension GMNRest {

    // MARK: Private Type Methods

    private static func _parseText(_ text: Substring) -> (String, GMNDuration?)? {
        let result = text.splitBeforeFirst([".", "*", "/"])
        let rtext = result.head

        guard let rest = (rtext == "_" ? String(rtext) : nil)
        else { return nil }

        guard let dtext = result.tail
        else { return (rest, nil) }

        return (rest, GMNDuration(dtext))
    }
}

// MARK: - Sendable

extension GMNRest: Sendable {
}
