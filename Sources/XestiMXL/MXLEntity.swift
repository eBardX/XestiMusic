// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLEntity {
    case container(MXLContainer)
    case opus(MXLOpus)
    case scorePartwise(MXLScorePW)
    case scoreTimewise(MXLScoreTW)
    case sounds([MXLStandardSound])
}

// MARK: - Sendable

extension MXLEntity: Sendable {
}
