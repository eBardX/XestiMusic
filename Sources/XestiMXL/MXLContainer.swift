// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLContainer {

    // MARK: Public Initializers

    public init(rootFiles: [MXLRootFile]) {
        self.rootFiles = rootFiles
    }

    // MARK: Public Instance Properties

    public let rootFiles: [MXLRootFile]
}

// MARK: - Sendable

extension MXLContainer: Sendable {
}
