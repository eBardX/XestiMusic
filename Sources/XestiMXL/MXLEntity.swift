// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLEntity {
    case container(MXLContainer)
    case opus(MXLOpus)
    case scorePartwise(MXLScore) // MXLScorePartwise ???
    case scoreTimewise(MXLScore) // MXLScoreTimewise ???
    case sounds([MXLSound])      // MXLStandardSound ???
}

// MARK: - Codable

extension MXLEntity: Codable {
}

// MARK: - Sendable

extension MXLEntity: Sendable {
}
