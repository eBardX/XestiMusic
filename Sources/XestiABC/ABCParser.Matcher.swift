// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension ABCParser {

    // MARK: Internal Nested Types

    internal struct Matcher {

        // MARK: Internal Initializers

        internal init(_ tokens: [Tokenizer.Token]) {
            self.tokenReader = TokenReader(tokens)
        }

        // MARK: Private Instance Properties

        private var tokenReader: TokenReader
    }
}

// MARK: -

extension ABCParser.Matcher {

    // MARK: Internal Instance Methods

    internal mutating func matchTunebook() throws -> ABCTunebook {
        //
        // tunebook => version header* tune*
        //
        let version = try _matchVersion()
        let headers = try _matchHeaders()
        let tunes = try _matchTunes()

        // guard !tokenReader.hasMore
        // else { throw Error.trailingGarbage }

        return ABCTunebook(version: version,
                           headers: headers,
                           tunes: tunes)
    }

    // MARK: Private Nested Types

    private typealias Error = ABCParser.Error

    // MARK: Private Type Properties

    private mutating func _matchCommentLine() throws {
        //
        // commentLine => <whitespace>? <comment> <eol>
        //
    }

    private mutating func _matchDirective() throws -> ABCDirective {
        //
        // directive => <directiveName> (<whitespace> <directiveValue>)? <whitespace>? <comment>? <eol>
        //

        ABCDirective(name: "",
                     value: nil)
    }

    private mutating func _matchEmptyLine() throws {
        //
        // emptyLine => <whitespace>? <eol>
        //
    }

    private mutating func _matchField() throws -> ABCField {
        //
        // field => ???
        //

        .area("")
    }

    private mutating func _matchHeader() throws -> ABCHeader {
        //
        // header => directive | field
        //

        try .directive(_matchDirective())
    }

    private mutating func _matchHeaders() throws -> [ABCHeader] {
        //
        // headers => header*
        //
        let headers: [ABCHeader] = []

        while true {
        }

        return headers
    }

    private mutating func _matchTunes() throws -> [ABCTune] {
        //
        // tunes => tune*
        //
        let tunes: [ABCTune] = []

        while true {
        }

        return tunes
    }

    private mutating func _matchVersion() throws -> ABCVersion {
        //
        // version => <fileID> <dash> <version> <whitespace>? <comment>? <eol>
        //

        ABCVersion(major: 0,
                   minor: 0)
    }
}
