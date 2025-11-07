// © 2025 John Gary Pusey (see LICENSE.md)

extension ABCKeySignature {
    public enum Tonic: String {
        case a      = "A"
        case aFlat  = "Ab"
        case aSharp = "A#"
        case b      = "B"
        case bFlat  = "Bb"
        case bSharp = "B#"
        case c      = "C"
        case cFlat  = "Cb"
        case cSharp = "C#"
        case d      = "D"
        case dFlat  = "Db"
        case dSharp = "D#"
        case e      = "E"
        case eFlat  = "Eb"
        case eSharp = "E#"
        case f      = "F"
        case fFlat  = "Fb"
        case fSharp = "F#"
        case g      = "G"
        case gFlat  = "Gb"
        case gSharp = "G#"
    }
}

// MARK: - Sendable

extension ABCKeySignature.Tonic: Sendable {
}
