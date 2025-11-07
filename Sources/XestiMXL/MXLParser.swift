// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools
import XestiXML

public struct MXLParser {

    // MARK: Public Initializers

    public init(_ data: Data) {
        self.baseParser = XestiXML.XMLParser(data)
    }

    // MARK: Private Instance Properties

    private let baseParser: XestiXML.XMLParser<MXLElement, MXLAttribute>
}

// MARK: -

extension MXLParser {

    // MARK: Public Instance Methods

    public func parse() throws -> MXLEntity {
        let rootNode = try baseParser.parse()

        switch rootNode.element {
        case .container:
            return try .container(Self._parseContainer(rootNode))

        case .opus:
            return try .opus(Self._parseOpus(rootNode))

        case .scorePartwise:
            return try .scorePartwise(Self._parseScore(rootNode, true))

        case .scoreTimewise:
            return try .scoreTimewise(Self._parseScore(rootNode, false))

        case .sounds:
            return try .sounds(Self._parseSounds(rootNode))

        default:
            try rootNode.unexpectedRootElement()

            fatalError("Logic error!")
        }
    }

    // MARK: Private Nested Types

    private typealias Node = XestiXML.XMLNode<MXLElement, MXLAttribute>

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

    private static func _makeStep(_ string: String) -> String? {
        if ["A", "B", "C", "D", "E", "F", "G"].contains(string) {
            string
        } else {
            nil
        }
    }

    private static func _makeTempo(_ string: String) -> Float? {
        if let tempo = Float(string),
           tempo > 0 {
            tempo
        } else {
            nil
        }
    }

    private static func _parseAttributes(_ node: Node) throws -> MXLMusicItem {
        //
        // Content ::= <divisions>?
        //
        try node.expectElement(.attributes)

        let divisions = try node.valueOfOptionalChildElement(.divisions) { _makeDivisions($0) }

        return .attributes(divisions)
    }

    private static func _parseBackup(_ node: Node) throws -> MXLMusicItem {
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

    private static func _parseForward(_ node: Node) throws -> MXLMusicItem {
        //
        // Content ::= <duration>
        //
        try node.expectElement(.forward)

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        return .forward(duration)
    }

    private static func _parseMeasure(_ node: Node,
                                      _ partwise: Bool) throws -> MXLMeasure {
        //
        // Content ::= ( <attributes> | <backup> | <forward> | <note> | <sound> )* (partwise)
        // Content ::= <part>+    (timewise)
        //
        try node.expectElement(.measure)

        let number = try node.valueOfRequiredAttribute(.number)

        let content: MXLMeasure.Content = if partwise {
            .partwise(try node.optionalChildElements([.attributes, .backup, .forward, .note, .sound]) {
                try _parseMusicItem($0)
            })
        } else {
            .timewise(try node.requiredChildElements(.part) { try _parsePart($0, false) })
        }

        return MXLMeasure(number: number,
                          content: content)
    }

    private static func _parseMusicItem(_ node: Node) throws -> MXLMusicItem {
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
            fatalError("Logic error!")
        }
    }

    private static func _parseNote(_ node: Node) throws -> MXLMusicItem {
        //
        // Content ::= <chord>? ( <pitch> | <unpitched> | <rest> ) <duration> <tie>{0,2}
        //
        try node.expectElement(.note)

        let chord = try node.valueOfOptionalChildElement(.chord) { $0.isEmpty }

        let value = try node.requiredChildElement([.pitch, .rest, .unpitched]) {
            try _parseNoteValue($0)
        }

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        let tie = try node.optionalChildElements(.tie) { try _parseTie($0) }.reduce(.neither, +)

        return .note(MXLNote(chord: chord,
                             value: value,
                             duration: duration,
                             tie: tie))
    }

    private static func _parseNoteValue(_ node: Node) throws -> MXLNote.Value {
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
            fatalError("Logic error!")
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
        }

        return MXLOpus(title: title,
                       items: items)
    }

    private static func _parseOpusItem(_ node: Node) throws -> MXLOpus.Item {
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
            fatalError("Logic error!")
        }
    }

    private static func _parsePart(_ node: Node,
                                   _ partwise: Bool) throws -> MXLPart {
        //
        // Content ::= <measure>+ (partwise)
        // Content ::= ( <attributes> | <backup> | <forward> | <note> | <sound> )* (timewise)
        //
        try node.expectElement(.part)

        let id = try node.valueOfRequiredAttribute(.id)

        let content: MXLPart.Content = if partwise {
            .partwise(try node.requiredChildElements(.measure) { try _parseMeasure($0, true) })
        } else {
            .timewise(try node.optionalChildElements([.attributes, .backup, .forward, .note, .sound]) {
                try _parseMusicItem($0)
            })
        }

        return MXLPart(id: id,
                       content: content)
    }

    private static func _parsePartList(_ node: Node) throws -> MXLPartList {
        //
        // Content ::= <score-part>+
        //
        try node.expectElement(.partList)

        let scoreParts = try node.requiredChildElements(.scorePart) { try _parseScorePart($0) }

        return MXLPartList(scoreParts: scoreParts)
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
                               alter: alter,
                               octave: octave))
    }

    private static func _parseRootFile(_ node: Node) throws -> MXLRootFile {
        try node.expectElement(.rootfile)

        let fullPath = try node.valueOfRequiredAttribute(.fullPath)

        let mediaType = try node.valueOfOptionalAttribute(.mediaType)

        return MXLRootFile(fullPath: fullPath,
                           mediaType: mediaType)
    }

    private static func _parseRootFiles(_ node: Node) throws -> [MXLRootFile] {
        //
        // Content ::= <rootfile>+
        //
        try node.expectElement(.rootfiles)

        let rootFiles = try node.requiredChildElements(.rootfile) { try _parseRootFile($0) }

        return rootFiles
    }

    private static func _parseScore(_ node: Node,
                                    _ partwise: Bool) throws -> MXLScore {
        //
        // Content ::= <work>? <movement-number>? <movement-title>? <part-list> <part>+    (partwise)
        // Content ::= <work>? <movement-number>? <movement-title>? <part-list> <measure>+ (timewise)
        //
        try node.expectElement(.scorePartwise)

        let work = try node.optionalChildElement(.work) { try _parseWork($0) }

        let movementNumber = try node.valueOfOptionalChildElement(.movementNumber)

        let movementTitle = try node.valueOfOptionalChildElement(.movementTitle)

        let partList = try node.requiredChildElement(.partList) { try _parsePartList($0) }

        let content: MXLScore.Content = if partwise {
            .partwise(try node.requiredChildElements(.part) { try _parsePart($0, true) })
        } else {
            .timewise(try node.requiredChildElements(.measure) { try _parseMeasure($0, false) })
        }

        return MXLScore(work: work,
                        movementNumber: movementNumber,
                        movementTitle: movementTitle,
                        partList: partList,
                        content: content)
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

    private static func _parseSound(_ node: Node) throws -> MXLMusicItem {
        try node.expectElement(.sound)

        let tempo = try node.valueOfOptionalAttribute(.tempo) { _makeTempo($0) }

        return .sound(tempo)
    }

    private static func _parseSounds(_ node: Node) throws -> [MXLSound] {
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
