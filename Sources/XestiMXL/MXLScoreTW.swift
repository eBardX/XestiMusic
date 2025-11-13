// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLScoreTW {

    // MARK: Public Initializers

    public init(work: MXLWork?,
                movementNumber: String?,
                movementTitle: String?,
                partList: MXLPartList,
                measures: [MXLMeasureTW]) {
        self.measures = measures
        self.movementNumber = movementNumber
        self.movementTitle = movementTitle
        self.partList = partList
        self.work = work
    }

    // MARK: Public Instance Properties

    public let measures: [MXLMeasureTW]
    public let movementNumber: String?
    public let movementTitle: String?
    public let partList: MXLPartList
    public let work: MXLWork?
}

// MARK: - Sendable

extension MXLScoreTW: Sendable {
}
