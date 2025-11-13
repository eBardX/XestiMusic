// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools
import XestiXML

public struct MXLParser {

    // MARK: Public Initializers

    public init() {
    }
}

// MARK: -

extension MXLParser {

    // MARK: Public Instance Methods

    public func parse(_ data: Data) throws -> MXLEntity {
        let rootNode = try BaseParser(data).parse()

        switch rootNode.element {
        case .container:
            return try .container(Self._parseContainer(rootNode))

        case .opus:
            return try .opus(Self._parseOpus(rootNode))

        case .scorePartwise:
            return try .scorePartwise(Self._parseScorePW(rootNode))

        case .scoreTimewise:
            return try .scoreTimewise(Self._parseScoreTW(rootNode))

        case .sounds:
            return try .sounds(Self._parseStandardSounds(rootNode))

        default:
            try rootNode.unexpectedRootElement()

            fatalError("Logic error!")
        }
    }

    // MARK: Private Nested Types

    private typealias BaseParser = XestiXML.XMLParser<MXLElement, MXLAttribute>
    private typealias Node       = XestiXML.XMLNode<MXLElement, MXLAttribute>

    // MARK: Private Type Methods

    private static func _makeAlter(_ string: String) -> Float? {
        if let alter = Float(string) {
            alter
        } else {
            nil
        }
    }

    private static func _makeDivisions(_ string: String) -> Int? {
        if let divisions = Int(string),
           divisions > 0 {
            divisions
        } else {
            nil
        }
    }

    private static func _makeDuration(_ string: String) -> Int? {
        if let duration = Int(string),
           duration > 0 {
            duration
        } else {
            nil
        }
    }

    private static func _makeOctave(_ string: String) -> Int? {
        if let octave = Int(string),
           (0...9).contains(octave) {
            octave
        } else {
            nil
        }
    }

    private static func _makeStep(_ string: String) -> MXLPitch.Step? {
        MXLPitch.Step(rawValue: string)
    }

    private static func _makeTempo(_ string: String) -> Float? {
        if let tempo = Float(string),
           tempo > 0 {
            tempo
        } else {
            nil
        }
    }

    private static func _parseAttributes(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <divisions>?
        //
        try node.expectElement(.attributes)

        guard let divisions = try node.valueOfOptionalChildElement(.divisions, { _makeDivisions($0) })
        else { return nil }

        return .attributes(divisions)
    }

    private static func _parseBackup(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <duration>
        //
        try node.expectElement(.backup)

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        return .backup(duration)
    }

    private static func _parseContainer(_ node: Node) throws -> MXLContainer {
        //
        // Content ::= <rootfiles>
        //
        try node.expectElement(.container)

        let rootFiles = try node.requiredChildElement(.rootfiles) { try _parseRootFiles($0) }

        return MXLContainer(rootFiles: rootFiles)
    }

    private static func _parseForward(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <duration>
        //
        try node.expectElement(.forward)

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        return .forward(duration)
    }

    private static func _parseMeasurePW(_ node: Node) throws -> MXLMeasurePW {
        //
        // Content ::= ( <attributes> | <backup> | <forward> | <note> | <sound> )*
        //
        try node.expectElement(.measure)

        let number = try node.valueOfRequiredAttribute(.number)

        let items = try node.optionalChildElements([.attributes, .backup, .forward, .note, .sound]) {
            try _parseMusicItem($0)
        }.compactMap { $0 }

        return MXLMeasurePW(number: number,
                            items: items)
    }

    private static func _parseMeasureTW(_ node: Node) throws -> MXLMeasureTW {
        //
        // Content ::= <part>+
        //
        try node.expectElement(.measure)

        let number = try node.valueOfRequiredAttribute(.number)

        let parts = try node.requiredChildElements(.part) { try _parsePartTW($0) }

        return MXLMeasureTW(number: number,
                            parts: parts)
    }

    private static func _parseMusicItem(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <attributes> | <backup> | <forward> | <note> | <sound>
        //
        try node.expectElement([.attributes, .backup, .forward, .note, .sound])

        switch node.element {
        case .attributes:
            return try _parseAttributes(node)

        case .backup:
            return try _parseBackup(node)

        case .forward:
            return try _parseForward(node)

        case .note:
            return try _parseNote(node)

        case .sound:
            return try _parseSound(node)

        default:
            return nil
        }
    }

    private static func _parseNote(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <chord>? ( <pitch> | <unpitched> | <rest> ) <duration> <tie>{0,2}
        //
        try node.expectElement(.note)

        let chord = try node.valueOfOptionalChildElement(.chord) { $0.isEmpty }

        let value = try node.requiredChildElement([.pitch, .rest, .unpitched]) {
            try _parseNoteValue($0)
        }

        guard let value
        else { return nil }

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        let tie = try node.optionalChildElements(.tie) { try _parseTie($0) }.reduce(.neither, +)

        return .note(MXLNote(chord: chord ?? false,
                             value: value,
                             duration: duration,
                             tie: tie))
    }

    private static func _parseNoteValue(_ node: Node) throws -> MXLNote.Value? {
        //
        // Content ::= <pitch> | <unpitched> | <rest>
        //
        try node.expectElement([.pitch, .rest, .unpitched])

        switch node.element {
        case .pitch:
            return try _parsePitch(node)

        case .rest:
            return .rest

        case .unpitched:
            return .unpitched

        default:
            return nil
        }
    }

    private static func _parseOpus(_ node: Node) throws -> MXLOpus {
        //
        // Content ::= <title> ( <opus> | <opus-link> | <score> )*
        //
        try node.expectElement(.opus)

        let title = try node.valueOfRequiredChildElement(.title)

        let items = try node.optionalChildElements([.opus, .opusLink, .score]) {
            try _parseOpusItem($0)
        }.compactMap { $0 }

        return MXLOpus(title: title,
                       items: items)
    }

    private static func _parseOpusItem(_ node: Node) throws -> MXLOpus.Item? {
        //
        // Content ::= <opus> | <opus-link> | <score>
        //
        try node.expectElement([.opus, .opusLink, .score])

        switch node.element {
        case .opus:
            return try .opus(_parseOpus(node))

        case .opusLink:
            return try .opusLink(node.valueOfRequiredAttribute(.xlinkHref))

        case .score:
            return try .score(node.valueOfRequiredAttribute(.xlinkHref))

        default:
            return nil
        }
    }

    private static func _parsePartList(_ node: Node) throws -> MXLPartList {
        //
        // Content ::= <score-part>+
        //
        try node.expectElement(.partList)

        let scoreParts = try node.requiredChildElements(.scorePart) { try _parseScorePart($0) }

        return MXLPartList(scoreParts: scoreParts)
    }

    private static func _parsePartPW(_ node: Node) throws -> MXLPartPW {
        //
        // Content ::= <measure>+
        //
        try node.expectElement(.part)

        let id = try node.valueOfRequiredAttribute(.id)

        let measures = try node.requiredChildElements(.measure) { try _parseMeasurePW($0) }

        return MXLPartPW(id: id,
                         measures: measures)
    }

    private static func _parsePartTW(_ node: Node) throws -> MXLPartTW {
        //
        // Content ::= ( <attributes> | <backup> | <forward> | <note> | <sound> )*
        //
        try node.expectElement(.part)

        let id = try node.valueOfRequiredAttribute(.id)

        let items = try node.optionalChildElements([.attributes, .backup, .forward, .note, .sound]) {
            try _parseMusicItem($0)
        }.compactMap { $0 }

        return MXLPartTW(id: id,
                         items: items)
    }

    private static func _parsePitch(_ node: Node) throws -> MXLNote.Value {
        //
        // Content ::= <step> <alter>? <octave>
        //
        try node.expectElement(.pitch)

        let step = try node.valueOfRequiredChildElement(.step) { _makeStep($0) }

        let alter = try node.valueOfOptionalChildElement(.alter) { _makeAlter($0) }

        let octave = try node.valueOfRequiredChildElement(.octave) { _makeOctave($0) }

        return .pitch(MXLPitch(step: step,
                               alter: alter ?? .zero,
                               octave: octave))
    }

    private static func _parseRootFile(_ node: Node) throws -> MXLRootFile {
        try node.expectElement(.rootfile)

        let fullPath = try node.valueOfRequiredAttribute(.fullPath)

        let mediaType = try node.valueOfOptionalAttribute(.mediaType)

        return MXLRootFile(fullPath: fullPath,
                           mediaType: mediaType ?? MXLRootFile.defaultMediaType)
    }

    private static func _parseRootFiles(_ node: Node) throws -> [MXLRootFile] {
        //
        // Content ::= <rootfile>+
        //
        try node.expectElement(.rootfiles)

        let rootFiles = try node.requiredChildElements(.rootfile) { try _parseRootFile($0) }

        return rootFiles
    }

    private static func _parseScorePart(_ node: Node) throws -> MXLScorePart {
        //
        // Content ::= <part-name>
        //
        try node.expectElement(.scorePart)

        let id = try node.valueOfRequiredAttribute(.id)

        let partName = try node.valueOfRequiredChildElement(.partName)

        return MXLScorePart(id: id,
                            partName: partName)
    }

    private static func _parseScorePW(_ node: Node) throws -> MXLScorePW {
        //
        // Content ::= <work>? <movement-number>? <movement-title>? <part-list> <part>+
        //
        try node.expectElement(.scorePartwise)

        let work = try node.optionalChildElement(.work) { try _parseWork($0) }

        let movementNumber = try node.valueOfOptionalChildElement(.movementNumber)

        let movementTitle = try node.valueOfOptionalChildElement(.movementTitle)

        let partList = try node.requiredChildElement(.partList) { try _parsePartList($0) }

        let parts = try node.requiredChildElements(.part) { try _parsePartPW($0) }

        return MXLScorePW(work: work,
                          movementNumber: movementNumber,
                          movementTitle: movementTitle,
                          partList: partList,
                          parts: parts)
    }

    private static func _parseScoreTW(_ node: Node) throws -> MXLScoreTW {
        //
        // Content ::= <work>? <movement-number>? <movement-title>? <part-list> <measure>+
        //
        try node.expectElement(.scoreTimewise)

        let work = try node.optionalChildElement(.work) { try _parseWork($0) }

        let movementNumber = try node.valueOfOptionalChildElement(.movementNumber)

        let movementTitle = try node.valueOfOptionalChildElement(.movementTitle)

        let partList = try node.requiredChildElement(.partList) { try _parsePartList($0) }

        let measures = try node.requiredChildElements(.measure) { try _parseMeasureTW($0) }

        return MXLScoreTW(work: work,
                          movementNumber: movementNumber,
                          movementTitle: movementTitle,
                          partList: partList,
                          measures: measures)
    }

    private static func _parseSound(_ node: Node) throws -> MXLMusicItem? {
        try node.expectElement(.sound)

        guard let tempo = try node.valueOfOptionalAttribute(.tempo, { _makeTempo($0) })
        else { return nil }

        return .sound(tempo)
    }

    private static func _parseStandardSounds(_ node: Node) throws -> [MXLStandardSound] {
        //
        // Content ::= <sound>+
        //
        try node.expectElement(.sounds)

        try node.unsupportedRootElement()

        return []
    }

    private static func _parseTie(_ node: Node) throws -> MXLTie {
        try node.expectElement(.tie)

        return try node.valueOfRequiredAttribute(.type) { MXLTie($0) }
    }

    private static func _parseWork(_ node: Node) throws -> MXLWork {
        //
        // Content ::= <work-number>? <work-title>?
        //
        try node.expectElement(.work)

        let workNumber = try node.valueOfOptionalChildElement(.workNumber)

        let workTitle = try node.valueOfOptionalChildElement(.workTitle)

        return MXLWork(workNumber: workNumber,
                       workTitle: workTitle)
    }
}
