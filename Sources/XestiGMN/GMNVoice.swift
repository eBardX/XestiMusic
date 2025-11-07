// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNVoice {

    // MARK: Public Initializers

    public init(_ symbols: [GMNSymbol]) {
        self.symbols = symbols
    }

    // MARK: Public Instance Properties

    public let symbols: [GMNSymbol]
}

// MARK: -

extension GMNVoice {

    // MARK: Public Instance Methods

    public func findAllTags(matching name: String) -> [GMNTag] {
        findAllTags(matching: [name])
    }

    public func findAllTags(matching names: [String]) -> [GMNTag] {
        findAllTags { names.contains($0.name) }
    }

    public func findAllTags(where predicate: (GMNTag) -> Bool) -> [GMNTag] {
        Self._findTags(symbols, true, predicate)
    }

    public func findFirstTag(matching name: String) -> GMNTag? {
        findFirstTag(matching: [name])
    }

    public func findFirstTag(matching names: [String]) -> GMNTag? {
        findFirstTag { names.contains($0.name) }
    }

    public func findFirstTag(where predicate: (GMNTag) -> Bool) -> GMNTag? {
        Self._findTags(symbols, false, predicate).first
    }

    // MARK: Private Type Methods

    private static func _findTags(_ symbols: [GMNSymbol],
                                  _ allTags: Bool,
                                  _ predicate: (GMNTag) -> Bool) -> [GMNTag] {
        var outTags: [GMNTag] = []

        for symbol in symbols {
            guard let tag = symbol.tagValue
            else { continue }

            if predicate(tag) {
                outTags.append(tag)

                if !allTags {
                    break
                }
            }

            let tags = _findTags(tag.symbols,
                                 allTags,
                                 predicate)

            if !tags.isEmpty {
                outTags.append(contentsOf: tags)

                if !allTags {
                    break
                }
            }
        }

        return outTags
    }
}

// MARK: - Sendable

extension GMNVoice: Sendable {
}
