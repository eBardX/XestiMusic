// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct ABCParser {

    // MARK: Public Initializers

    public init() {
        self.tokenizer = ABCTokenizer(tracing: .verbose)
    }

    // MARK: Internal Instance Properties

    private let tokenizer: ABCTokenizer
}

// MARK: -

extension ABCParser {

    // MARK: Public Instance Methods

    public func parse(_ data: Data) throws -> ABCTunebook {
        guard let input = String(data: data,
                                 encoding: .utf8)
        else { throw Error.dataConversionFailed }

       var matcher = try Matcher(tokenizer.tokenize(input))

       return try matcher.matchTunebook()
    }
}
