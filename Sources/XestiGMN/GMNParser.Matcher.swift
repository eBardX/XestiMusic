// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension GMNParser {

    // MARK: Internal Nested Types

    internal struct Matcher {

        // MARK: Internal Initializers

        internal init(_ tokens: [Tokenizer.Token]) {
            self.tokenReader = TokenReader(tokens)
        }

        // MARK: Internal Instance Properties

        private var tokenReader: TokenReader
    }
}

// MARK: -

extension GMNParser.Matcher {

    // MARK: Internal Nested Types

    internal typealias Error = GMNParser.Error

    // MARK: Internal Instance Methods

    internal mutating func matchScore() throws -> GMNScore {
        //
        // score => variables? voices
        //
        let variables = try _matchVariables()
        let voices = try _matchVoices()

        guard !tokenReader.hasMore
        else { throw Error.trailingGarbage }

        return GMNScore(variables, voices)
    }

    // MARK: Private Instance Methods

    private mutating func _matchChord() throws -> GMNSymbol? {
        //
        // chord => <curlyBracketOpen> symbol[inChord]+ (<comma> symbol[inChord]+)* <curlyBracketClose>
        //
        guard tokenReader.readIfMatches(.curlyBracketOpen) != nil
        else { return nil }

        var segments: [GMNChord.Segment] = []

        while true {
            var symbols: [GMNSymbol] = []
            var musicSymbolSeen = false

            while let symbol = try _matchSymbol(inChord: true) {
                symbols.append(symbol)

                if symbol.isMusic {
                    guard !musicSymbolSeen
                    else { throw Error.invalidChordSegment(symbols) }

                    musicSymbolSeen = true
                }
            }

            guard musicSymbolSeen
            else { throw Error.invalidChordSegment(symbols) }

            guard let segment = GMNChord.Segment(symbols)
            else { throw Error.nestedChord }

            segments.append(segment)

            guard tokenReader.readIfMatches(.comma) != nil
            else { break }
        }

        try tokenReader.readMustMatch(.curlyBracketClose)

        return .chord(GMNChord(segments))
    }

    private mutating func _matchNote() throws -> GMNSymbol? {
        guard let token = tokenReader.readIfMatches([.note])
        else { return nil }

        guard let note = GMNNote(token.value)
        else { throw Error.invalidNote(token.value) }

        return .note(note)
    }

    private mutating func _matchParameterUnit() -> String? {
        guard let token = tokenReader.readIfMatches(.unit)
        else { return nil }

        return String(token.value)
    }

    private mutating func _matchRest() throws -> GMNSymbol? {
        guard let token = tokenReader.readIfMatches([.rest])
        else { return nil }

        guard let rest = GMNRest(token.value)
        else { throw Error.invalidRest(token.value) }

        return .rest(rest)
    }

    private mutating func _matchSymbol(inChord: Bool) throws -> GMNSymbol? {
        //
        // symbol => chord | <note> | <rest> | <tablature> | tag | <variableName>
        //
        if tokenReader.nextMatches(.curlyBracketOpen) {
            guard !inChord
            else { throw Error.nestedChord }

            return try _matchChord()
        }

        if tokenReader.nextMatches([.note]) {
            return try _matchNote()
        }

        if tokenReader.nextMatches([.rest]) {
            return try _matchRest()
        }

        if tokenReader.nextMatches([.tablature]) {
            return try _matchTablature()
        }

        if tokenReader.nextMatches([.tagName]) {
            return try _matchTag(inChord: inChord)
        }

        if tokenReader.nextMatches(.variableName) {
            return try _matchVariable()
        }

        return nil
    }

    private mutating func _matchTablature() throws -> GMNSymbol? {
        guard let token = tokenReader.readIfMatches(.tablature)
        else { return nil }

        guard let tablature = GMNTablature(token.value)
        else { throw Error.invalidTablature(token.value) }

        return .tablature(tablature)
    }

    private mutating func _matchTag(inChord: Bool) throws -> GMNSymbol? {
        //
        // tag => <tagName> (<angleBracketOpen> tagParameters <angleBracketClose>)? (<roundBracketOpen> symbol+ <roundBracketClose>)?
        //
        guard let token = tokenReader.readIfMatches(.tagName)
        else { return nil }

        let (name, ident) = _splitTagNameIdent(token.value)

        let parameters: [GMNTag.Parameter]

        if tokenReader.readIfMatches(.angleBracketOpen) != nil {
            parameters = try _matchTagParameters()

            try tokenReader.readMustMatch(.angleBracketClose)
        } else {
            parameters = []
        }

        var symbols: [GMNSymbol] = []

        if tokenReader.readIfMatches(.roundBracketOpen) != nil {
            while let symbol = try _matchSymbol(inChord: inChord) {
                symbols.append(symbol)
            }

            try tokenReader.readMustMatch(.roundBracketClose)
        } else {
            symbols = []
        }

        return .tag(GMNTag(name,
                           ident,
                           parameters,
                           symbols))
    }

    private mutating func _matchTagParameter() throws -> GMNTag.Parameter? {
        //
        // tagParameter => (<parameterName> <equalSign>)? tagValue
        //
        let name: String?

        if let token = tokenReader.readIfMatches(.parameterName) {
            try tokenReader.readMustMatch(.equalSign)

            name = String(token.value)
        } else {
            name = nil
        }

        return try _matchTagValue(name)
    }

    private mutating func _matchTagParameters() throws -> [GMNTag.Parameter] {
        //
        // tagParameters => tagParameter (<comma> tagParameter)*
        //
        var params: [GMNTag.Parameter] = []

        while let param = try _matchTagParameter() {
            params.append(param)

            guard tokenReader.readIfMatches(.comma) != nil
            else { break }
        }

        return params
    }

    private mutating func _matchTagValue(_ name: String?) throws -> GMNTag.Parameter? {
        //
        // tagValue => <floatingValue> <unit>?
        //           | <integerValue> <unit>?
        //           | <parameterName>
        //           | <stringValue>
        //           | <variableName>
        //
        if let token = tokenReader.readIfMatches(.floatingValue) {
            guard let value = Double(token.value)
            else { throw Error.invalidNumber(token.value) }

            let unit = _matchParameterUnit()

            return .floating(name: name,
                             value: value,
                             unit: unit)
        }

        if let token = tokenReader.readIfMatches(.integerValue) {
            guard let value = Int(token.value)
            else { throw Error.invalidNumber(token.value) }

            let unit = _matchParameterUnit()

            return .integer(name: name,
                            value: value,
                            unit: unit)
        }

        if let token = tokenReader.readIfMatches(.parameterName) {
            return .parameter(name: name,
                              value: String(token.value))
        }

        if let token = tokenReader.readIfMatches(.stringValue) {
            guard let cvtValue = _convertString(token.value)
            else { throw Error.invalidString(token.value) }

            return .string(name: name,
                           value: cvtValue)
        }

        if let token = tokenReader.readIfMatches(.variableName) {
            return .variable(name: name,
                             value: String(token.value))
        }

        return nil
    }

    private mutating func _matchVariable() throws -> GMNSymbol {
        try .variable(_matchVariableName())
    }

    private mutating func _matchVariableDeclaration() throws -> GMNVariable {
        //
        // variableDeclaration => <variableName> <equalSign> <floatingValue> <semicolon>
        //                     | <variableName> <equalSign> <integerValue> <semicolon>
        //                     | <variableName> <equalSign> <stringValue> <semicolon>
        //
        let name = try _matchVariableName()

        try tokenReader.readMustMatch(.equalSign)

        guard let value = try _matchVariableValue()
        else { throw Error.missingVariableValue }

        try tokenReader.readMustMatch(.semicolon)

        return GMNVariable(name, value)
    }

    private mutating func _matchVariableName() throws -> String {
        try String(tokenReader.readMustMatch(.variableName).value)
    }

    private mutating func _matchVariables() throws -> [GMNVariable] {
        //
        // variables => variableDeclaration+
        //
        var variables: [GMNVariable] = []

        while tokenReader.nextMatches(.variableName) {
            try variables.append(_matchVariableDeclaration())
        }

        return variables
    }

    private mutating func _matchVariableValue() throws -> GMNVariable.Value? {
        if let token = tokenReader.readIfMatches(.floatingValue) {
            guard let cvtValue = _convertFloating(token.value)
            else { throw Error.invalidNumber(token.value) }

            return .floating(cvtValue)
        }

        if let token = tokenReader.readIfMatches(.integerValue) {
            guard let cvtValue = _convertInteger(token.value)
            else { throw Error.invalidNumber(token.value) }

            return .integer(cvtValue)
        }

        if let token = tokenReader.readIfMatches(.stringValue) {
            guard let cvtValue = _convertString(token.value)
            else { throw Error.invalidString(token.value) }

            return .string(cvtValue)
        }

        return nil
    }

    private mutating func _matchVoice() throws -> GMNVoice {
        //
        // voice => <squareBracketOpen> symbol* <squareBracketClose>
        //
        var symbols: [GMNSymbol] = []

        try tokenReader.readMustMatch(.squareBracketOpen)

        while let symbol = try _matchSymbol(inChord: false) {
            symbols.append(symbol)
        }

        try tokenReader.readMustMatch(.squareBracketClose)

        return GMNVoice(symbols)
    }

    private mutating func _matchVoices() throws -> [GMNVoice] {
        //
        // voices => <curlyBracketOpen> (voice (<comma> voice)*) <curlyBracketClose>
        //         | voice
        //
        var voices: [GMNVoice] = []

        if tokenReader.readIfMatches(.curlyBracketOpen) != nil {
            while !tokenReader.nextMatches(.curlyBracketClose) {
                try voices.append(_matchVoice())

                tokenReader.readIfMatches(.comma)
            }

            try tokenReader.readMustMatch(.curlyBracketClose)
        } else {
            try voices.append(_matchVoice())
        }

        return voices
    }
}

// MARK: -

extension GMNParser.Matcher {
}

// MARK: - Private Functions

private func _convertEscapedCharacter(_ reader: inout SequenceReader<Substring>) -> Character? {
    guard let chr = reader.read()
    else { return nil }

    switch chr {
    case "\"", "\\", "'":
        return chr

    case "n":
        return "\u{0a}"

    default:
        return nil
    }
}

private func _convertFloating(_ text: Substring) -> Double? {
    Double(text)
}

private func _convertInteger(_ text: Substring) -> Int? {
    Int(text)
}

private func _convertString(_ text: Substring) -> String? {
    var reader = SequenceReader<Substring>(text)

    guard let delimiter = reader.read()
    else { return nil }

    var cvtValue = ""

    while let chr = reader.read() {
        if chr == "\\" {
            guard let cvtChr = _convertEscapedCharacter(&reader)
            else { return nil }

            cvtValue.append(cvtChr)
        } else if chr != delimiter {
            cvtValue.append(chr)
        } else {
            return cvtValue
        }
    }

    return nil
}

private func _splitTagNameIdent(_ text: Substring) -> (String, UInt?) {
    let result = text.splitBeforeFirst(":")
    let name = String(result.head)

    if let itext = result.tail?.dropFirst(),
       let ident = UInt(itext) {
        return (name, ident)
    }

    return (name, nil)
}
