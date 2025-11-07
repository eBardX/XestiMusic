// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct GMNParser {

    // MARK: Public Initializers

    public init() {
        self.tokenizer = GMNTokenizer(tracing: .silent)
    }

    // MARK: Internal Instance Properties

    private let tokenizer: GMNTokenizer
}

// MARK: -

extension GMNParser {

    // MARK: Public Instance Methods

    public func parse(_ data: Data) throws -> GMNScore {
         guard let input = String(data: data,
                                  encoding: .utf8)
         else { throw Error.dataConversionFailed }

        var matcher = try Matcher(tokenizer.tokenize(input))

        return try matcher.matchScore()
    }
}
