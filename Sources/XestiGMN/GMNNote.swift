// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct GMNNote {

    // MARK: Public Initializers

    public init?(_ text: Substring) {
        guard let (pitch, duration) = Self._parseText(text)
        else { return nil }

        self.duration = duration
        self.pitch = pitch
    }

    // MARK: Public Instance Properties

    public let duration: GMNDuration?
    public let pitch: GMNPitch
}

// MARK: -

extension GMNNote {

    // MARK: Private Type Methods

    private static func _parseText(_ text: Substring) -> (GMNPitch, GMNDuration?)? {
        let result = text.splitBeforeFirst([".", "*", "/"])
        let ptext = result.head

        guard let pitch = GMNPitch(ptext)
        else { return nil }

        guard let dtext = result.tail
        else { return (pitch, nil) }

        return (pitch, GMNDuration(dtext))
    }
}

// MARK: - Sendable

extension GMNNote: Sendable {
}
