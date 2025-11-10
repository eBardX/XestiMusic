// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLScorePartwise {

    // MARK: Public Initializers

    public init(work: MXLWork?,
                movementNumber: String?,
                movementTitle: String?,
                partList: MXLPartList,
                parts: [MXLPartPartwise]) {
        self.movementNumber = movementNumber
        self.movementTitle = movementTitle
        self.partList = partList
        self.parts = parts
        self.work = work
    }

    // MARK: Public Instance Properties

    public let movementNumber: String?
    public let movementTitle: String?
    public let partList: MXLPartList
    public let parts: [MXLPartPartwise]
    public let work: MXLWork?
}

// MARK: - Codable

extension MXLScorePartwise: Codable {
}

// MARK: - Sendable

extension MXLScorePartwise: Sendable {
}
