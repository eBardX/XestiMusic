// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLEntity {
    case container(MXLContainer)
    case opus(MXLOpus)
    case scorePartwise(MXLScorePartwise)
    case scoreTimewise(MXLScoreTimewise)
    case sounds([MXLStandardSound])
}

// MARK: - Sendable

extension MXLEntity: Sendable {
}
