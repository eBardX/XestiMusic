// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiMXL
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpMusicXML(_ fileURL: URL) throws {
        let compressed = fileURL.pathExtension == "mxl"

        var banner = "Dump of "

        if compressed {
            banner += "Compressed "
        }

        banner += "MusicXML Document "
        banner += format(fileURL.path)

        emit()
        emit(banner)

        if compressed {
            let file = try unzipArchive(fileURL)
            let conFile = try file.findFile("META-INF/container.xml")
            let data = try conFile.contentsOfRegularFile()
            let entity = try MXLParser(data).parse()

            guard case let .container(container) = entity
            else { throw MXLParser.Error.parseFailure(nil) }

            try _dump(2, container, file)
        } else {
            let entity = try MXLParser(readFile(fileURL)).parse()

            _dump(2, entity)
        }

        emit()
    }

    // MARK: Private Type Properties

    private static let mediaTypes = ["application/musicxml+xml",
                                     "application/vnd.recordare.musicxml+xml"]

    // MARK: Private Instance Methods

    private func _dump(_ indent: Int,
                       _ container: MXLContainer,
                       _ file: FileWrapper) throws {
        guard let rootFile = container.rootFiles.first
        else { throw MXLParser.Error.noRootFileFound }

        if let mediaType = rootFile.mediaType {
            guard Self.mediaTypes.contains(mediaType)
            else { throw MXLParser.Error.invalidRootFileMediaType(mediaType) }
        }

        emit()
        emit(indent, _format(rootFile))

        let realFile = try file.findFile([rootFile.fullPath])
        let data = try realFile.contentsOfRegularFile()
        let entity = try MXLParser(data).parse()

        _dump(indent + 2, entity)
    }

    private func _dump(_ indent: Int,
                       _ entity: MXLEntity) {
        switch entity {
            // case let .opus(opus):
            //     _dump(indent, opus)

        case let .scorePartwise(score):
            _dump(indent, score)

            // case let .scoreTimewise(score):
            //     _dump(indent, score)

        default:
            fatalError("Not yet implemented")
        }
    }

    private func _dump(_ indent: Int,
                       _ item: MXLMusicItem) {
        var line = ""

        switch item {
        case let .attributes(divisions):
            line += "Divisions"
            line += spacer()

            if let divisions {
                line += format(divisions)
            } else {
                line += "Unknown"
            }

        case let .backup(duration):
            line += "Backup"
            line += spacer()
            line += format(duration)

        case let .forward(duration):
            line += "Forward"
            line += spacer()
            line += format(duration)

        case let .note(note):
            line += _format(note)

        case let .sound(tempo):
            line += "Tempo"
            line += spacer()

            if let tempo {
                line += format(Int(tempo))
                line += " bpm"
            } else {
                line += "Unknown"
            }
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ measure: MXLMeasurePartwise) {
        let items = measure.items

        var header = "Measure "

        header += format(measure.number,
                         quoteAndEscape: false)
        header += spacer()
        header += format(items.count, "item")

        emit()
        emit(indent, header)

        if !items.isEmpty {
            emit()

            for item in items {
                _dump(indent + 2, item)
            }
        }
    }

    private func _dump(_ indent: Int,
                       _ movementNumber: String?,
                       _ movementTitle: String?) {
        var line = "Movement"

        if let movementNumber {
            line += spacer()
            line += format(movementNumber)
        }

        if let movementTitle {
            line += spacer()
            line += format(movementTitle)
        }

        emit()
        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ partList: MXLPartList) {
        let scoreParts = partList.scoreParts

        var header = "Part-list"

        header += spacer()
        header += format(scoreParts.count, "score-part")

        emit()
        emit(indent, header)
        emit()

        for scorePart in scoreParts {
            _dump(indent + 2, scorePart)
        }
    }

    private func _dump(_ indent: Int,
                       _ part: MXLPartPartwise) {
        let measures = part.measures

        var header = "Part "

        header += format(part.id)
        header += spacer()
        header += format(measures.count, "measure")

        emit()
        emit(indent, header)

        for measure in measures {
            _dump(indent + 2, measure)
        }
    }

    private func _dump(_ indent: Int,
                       _ scorePart: MXLScorePart) {
        var line = "Score-part "

        line += format(scorePart.id)
        line += spacer()
        line += format(scorePart.partName)

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ score: MXLScorePartwise) {
        let parts = score.parts

        var header = "Score"

        header += spacer()
        header += "Partwise"
        header += spacer()
        header += format(parts.count, "part")

        emit()
        emit(indent, header)

        if let work = score.work {
            _dump(indent + 2, work)
        }

        _dump(indent + 2,
              score.movementNumber,
              score.movementTitle)

        _dump(indent + 2, score.partList)

        for part in parts {
            _dump(indent + 2, part)
        }
    }

    private func _dump(_ indent: Int,
                       _ work: MXLWork) {
        var line = "Work"

        if let workNumber = work.workNumber {
            line += spacer()
            line += format(workNumber)
        }

        if let workTitle = work.workTitle {
            line += spacer()
            line += format(workTitle)
        }

        emit()
        emit(indent, line)
    }

    private func _format(_ note: MXLNote) -> String {
        var line = ""

        line += _format(note.value)
        line += spacer()
        line += format(note.duration)

        if let chord = note.chord, chord {
            line += spacer()
            line += "Chord"
        }

        if let result = _format(note.tie) {
            line += spacer()
            line += result
        }

        return line
    }

    private func _format(_ pitch: MXLPitch) -> String {
        var result = "<"

        result += format(pitch.step)

        if let alter = pitch.alter {
            result += ", "
            result += format(alter)
        }

        result += ", "
        result += format(pitch.octave)
        result += ">"

        return result
    }

    private func _format(_ rootFile: MXLRootFile) -> String {
        var line = "Root file"

        line += spacer()
        line += format(rootFile.fullPath)

        if let mediaType = rootFile.mediaType {
            line += " ["
            line += format(mediaType,
                           quoteAndEscape: false)
            line += "]"
        }

        return line
    }

    private func _format(_ tie: MXLTie) -> String? {
        switch tie {
        case .neither:
            nil

        case .start:
            "Start tie"

        case .stop:
            "Stop tie"

        case .stopStart:
            "Stop/start tie"
        }
    }

    private func _format(_ value: MXLNote.Value) -> String {
        switch value {
        case let .pitch(pitch):
            "Pitch" + spacer() + _format(pitch)

        case .rest:
            "Rest"

        case .unpitched:
            "Unpitched"
        }
    }
}
