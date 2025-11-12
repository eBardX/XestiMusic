// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

public struct SMFParser {

    // MARK: Public Initializers

    public init() {
    }
}

// MARK: -

extension SMFParser {

    // MARK: Public Instance Methods

    public func parse(_ data: Data) throws -> SMFSequence {
        var reader = Reader(data)

        return try reader.readSequence()
    }
}
