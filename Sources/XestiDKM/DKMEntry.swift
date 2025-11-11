// © 2025 John Gary Pusey (see LICENSE.md)

public struct DKMEntry {

    // MARK: Public Initializers

    public init(_ command: DKMCommand,
                _ arguments: Any...) {
        self.command = command
        self.arguments = arguments.map { DKMArgument($0) }
    }

    // MARK: Public Instance Properties

    public let command: DKMCommand
    public let arguments: [DKMArgument]
}

// MARK: - Sendable

extension DKMEntry: Sendable {
}
