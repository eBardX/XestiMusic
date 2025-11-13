// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLScorePW {

    // MARK: Public Initializers

    public init(work: MXLWork?,
                movementNumber: String?,
                movementTitle: String?,
                partList: MXLPartList,
                parts: [MXLPartPW]) {
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
    public let parts: [MXLPartPW]
    public let work: MXLWork?
}

// MARK: - Sendable

extension MXLScorePW: Sendable {
}
