// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

public struct ABCParser {

    // MARK: Public Initializers

    public init(_ data: Data) {
        self.preprocessor = ABCPreprocessor(data)
    }

    // MARK: Internal Instance Properties

    private var preprocessor: ABCPreprocessor
}

// MARK: -

extension ABCParser {

    // MARK: Public Instance Methods

    public mutating func parse() throws -> [ABCTune] {
        while let line = try preprocessor.nextLine() {
            let parsedLine = try _parseLine(line)

            print(parsedLine)
        }

        return []
    }

    // MARK: Private Instance Methods

    private func _parseLine(_ line: String) throws -> Line {
        guard !line.isEmpty
        else { return .empty }

        if ABCFileID.canParse(line) {
            return try .fileID(.parse(line))
        }

        if ABCDirective.canParse(line) {
            return try .directive(.parse(line))
        }

        if ABCField.canParse(line) {
            return try .field(.parse(line))
        }

        return try .symbols(ABCSymbol.parseSymbols(line))
    }
}
