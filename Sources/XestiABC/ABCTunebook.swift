// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTunebook {

    // MARK: Public Initializers

    public init(version: ABCVersion,
                headers: [ABCHeader],
                tunes: [ABCTune]) {
        self.headers = headers
        self.tunes = tunes
        self.version = version
    }

    // MARK: Public Instance Properties

    public let headers: [ABCHeader]
    public let tunes: [ABCTune]
    public let version: ABCVersion
}

// MARK: - Sendable

extension ABCTunebook: Sendable {
}
