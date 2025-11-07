// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLWork {

    // MARK: Public Initializers

    public init(workNumber: String?,
                workTitle: String?) {
        self.workNumber = workNumber
        self.workTitle = workTitle
    }

    // MARK: Public Instance Properties

    public let workNumber: String?
    public let workTitle: String?
}

// MARK: - Codable

extension MXLWork: Codable {
}

// MARK: - Sendable

extension MXLWork: Sendable {
}
