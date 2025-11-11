// © 2025 John Gary Pusey (see LICENSE.md)

extension MXLNote {
    public enum Value {
        case pitch(MXLPitch)
        case rest
        case unpitched
    }
}

// MARK: - Sendable

extension MXLNote.Value: Sendable {
}
