// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLMusicItem {
    case attributes(MXLDuration)
    case backup(MXLDuration)
    case forward(MXLDuration)
    case note(MXLNote)
    case sound(Float)
}

// MARK: - Sendable

extension MXLMusicItem: Sendable {
}
