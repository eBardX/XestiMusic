// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLScore {

    // MARK: Public Initializers

    public init(work: MXLWork?,
                movementNumber: String?,
                movementTitle: String?,
                partList: MXLPartList,
                content: Content) {
        self.content = content
        self.movementNumber = movementNumber
        self.movementTitle = movementTitle
        self.partList = partList
        self.work = work
    }

    // MARK: Public Instance Properties

    public let content: Content
    public let movementNumber: String?
    public let movementTitle: String?
    public let partList: MXLPartList
    public let work: MXLWork?
}

// MARK: - Codable

extension MXLScore: Codable {
}

// MARK: - Sendable

extension MXLScore: Sendable {
}
