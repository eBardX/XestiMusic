// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLMusicItem {
    case attributes(Int)
    case backup(Int)
    case forward(Int)
    case note(MXLNote)
    case sound(Float)
}

// MARK: - Sendable

extension MXLMusicItem: Sendable {
}
