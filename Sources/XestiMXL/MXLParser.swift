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

    public func parse(_ data: Data,
                      compressed: Bool) throws -> MXLEntity {
        if compressed {
            let arcFile = try data.unzip()

            switch try Self._parse(Self._readContainerData(from: arcFile)) {
            case let .container(container):
                return try Self._parse(Self._readRootData(from: arcFile,
                                                          in: container))

            default:
                throw Error.parseFailure(nil)
            }
        }

        return try Self._parse(data)
    }

    // MARK: Private Nested Types

    private typealias BaseParser = XestiXML.XMLParser<MXLElement, MXLAttribute>
    private typealias Node       = XestiXML.XMLNode<MXLElement, MXLAttribute>

    // MARK: Private Type Properties

    private static let containerFileName     = "container.xml"
    private static let metaInfoDirectoryName = "META-INF"
    private static let validMediaTypes       = [MXLRootFile.uncompressedMediaType,
                                                MXLRootFile.oldUncompressedMediaType]

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

    private static func _makePercent(_ string: String) -> Float? {
        if let percent = Float(string),
           percent > 0 {
            percent
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

    private static func _parse(_ data: Data) throws -> MXLEntity {
        let rootNode = try BaseParser(data).parse()

        switch rootNode.element {
        case .container:
            return try .container(_parseContainer(rootNode))

        case .opus:
            return try .opus(_parseOpus(rootNode))

        case .scorePartwise:
            return try .scorePartwise(_parseScorePW(rootNode))

        case .scoreTimewise:
            return try .scoreTimewise(_parseScoreTW(rootNode))

        case .sounds:
            return try .sounds(_parseStandardSounds(rootNode))

        default:
            try rootNode.unexpectedRootElement()

            fatalError("Logic error!")
        }
    }

    private static func _parseAttributes(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <divisions>?
        //
        try node.expectElement(.attributes)

        guard let divisions = try node.valueOfOptionalChildElement(.divisions, { _makeDivisions($0) })
        else { return nil }

        return .attributes(.divisions(divisions))
    }

    private static func _parseBackup(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <duration>
        //
        try node.expectElement(.backup)

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        return .backup(.divisions(duration))
    }

    private static func _parseContainer(_ node: Node) throws -> MXLContainer {
        //
        // Content ::= <rootfiles>
        //
        try node.expectElement(.container)

        let rootFiles = try node.requiredChildElement(.rootfiles) { try _parseRootFiles($0) }

        return MXLContainer(rootFiles: rootFiles)
    }

    private static func _parseDuration(_ node: Node) throws -> MXLDuration? {
        //
        // Content ::= <duration> | <grace>
        //
        try node.expectElement([.duration, .grace])

        switch node.element {
        case .duration:
            let duration = try node.valueOfExpectedElement(.duration) { _makeDuration($0) }

            return .divisions(duration)

        case .grace:
            if let value = try node.valueOfOptionalAttribute(.stealTimeFollowing, { _makePercent($0) }) {
                return .stealFollowing(value)
            }

            if let value = try node.valueOfOptionalAttribute(.stealTimePrevious, { _makePercent($0) }) {
                return .stealPrevious(value)
            }

            if let value = try node.valueOfOptionalAttribute(.makeTime, { _makeDivisions($0) }) {
                return .makeTime(Float(value))
            }

            return .unspecified

        default:
            return nil
        }
    }

    private static func _parseForward(_ node: Node) throws -> MXLMusicItem? {
        //
        // Content ::= <duration>
        //
        try node.expectElement(.forward)

        let duration = try node.valueOfRequiredChildElement(.duration) { _makeDuration($0) }

        return .forward(.divisions(duration))
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
        // Content ::= <cue> … -- ignore completely
        // Content ::= <grace> <chord>? ( <pitch> | <unpitched> | <rest> ) <tie>{0,2}
        // Content ::= <chord>? ( <pitch> | <unpitched> | <rest> ) <duration> <tie>{0,2}
        //
        try node.expectElement(.note)

        guard !node.hasChildElement(.cue)
        else { return nil }

        let isChord = try node.valueOfOptionalChildElement(.chord) { $0.isEmpty } ?? false

        let value = try node.requiredChildElement([.pitch, .rest, .unpitched]) {
            try _parseNoteValue($0)
        }

        guard let value
        else { return nil }

        let duration = try node.requiredChildElement([.duration, .grace]) {
            try _parseDuration($0)
        }

        guard let duration
        else { return nil }

        let tie = try node.optionalChildElements(.tie) { try _parseTie($0) }.reduce(.neither, +)

        return .note(MXLNote(isChord: isChord,
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

    private static func _readContainerData(from file: FileWrapper) throws -> Data {
        try file.findFile([metaInfoDirectoryName,
                           containerFileName]).contentsOfRegularFile()
    }

    private static func _readRootData(from file: FileWrapper,
                                      in container: MXLContainer) throws -> Data {
        guard let rootFile = container.rootFiles.first
        else { throw Error.noRootFileFound }

        guard Self.validMediaTypes.contains(rootFile.mediaType)
        else { throw Error.invalidRootFileMediaType(rootFile.mediaType) }

        return try file.findFile([rootFile.fullPath]).contentsOfRegularFile()
    }
}
