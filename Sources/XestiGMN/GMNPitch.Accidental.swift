// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNPitch {
    public enum Accidental: String {
        case doubleFlat  = "&&"
        case flat        = "&"
        case sharp       = "#"
        case doubleSharp = "##"
    }
}

// MARK: - Sendable

extension GMNPitch.Accidental: Sendable {
}
