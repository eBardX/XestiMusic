// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLMusicItem {
    case attributes(UInt)
    case backup(UInt)
    case forward(UInt)
    case graceNote(MXLGraceNote)
    case note(MXLNote)
    case sound(Float)
}

// MARK: - Sendable

extension MXLMusicItem: Sendable {
}
