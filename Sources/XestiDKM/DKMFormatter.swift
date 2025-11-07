// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

public struct DKMFormatter {

    // MARK: Public Initializers

    public init(_ score: DKMScore) {
        self.buffer = ""
        self.previous = .comment
        self.score = score
    }

    // MARK: Private Instance Properties

    private let score: DKMScore

    private var buffer: String
    private var previous: DKMCommand
}

// MARK: -

extension DKMFormatter {

    // MARK: Public Instance Methods

    public mutating func format() throws -> Data {
        for entry in score.entries {
            try _format(entry)
        }

        guard let data = buffer.data(using: .utf8)
        else { throw Error.stringConversionFailed }

        return data
    }

    // MARK: Private Instance Methods

    private mutating func _format(_ argument: DKMArgument) throws {
        switch argument {
        case let .double(value):
            buffer.append("\(value)")

        case let .string(value):
            buffer.append(value)
        }
    }

    private mutating func _format(_ arguments: [DKMArgument]) throws {
        guard !arguments.isEmpty
        else { return }

        var first = true

        for argument in arguments {
            if !first {
                buffer.append(" ")
            } else {
                first = false
            }

            try _format(argument)
        }

        buffer.append("\n")
    }

    private mutating func _format(_ command: DKMCommand) throws {
        buffer.append("/")
        buffer.append(command.rawValue)
        buffer.append("\n")
    }

    private mutating func _format(_ entry: DKMEntry) throws {
        switch entry.command {
        case .comment:
            buffer.append("!")  // no newline unless no arguments

            if entry.arguments.isEmpty {
                buffer.append("\n")
            }

        default:
            if previous != entry.command {
                try _format(entry.command)
            }
        }

        previous = entry.command

        try _format(entry.arguments)
    }
}
