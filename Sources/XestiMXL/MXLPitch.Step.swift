// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLPitch {
    public enum Step: String {
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
        case e = "E"
        case f = "F"
        case g = "G"
    }
}

// MARK: - Sendable

extension MXLPitch.Step: Sendable {
}
