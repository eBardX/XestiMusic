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

            try _dump(container, file)
        } else {
            let entity = try MXLParser(readFile(fileURL)).parse()

            _dump(entity)
        }

        emit()
    }

    // MARK: Private Type Properties

    private static let mediaTypes = ["application/musicxml+xml",
                                     "application/vnd.recordare.musicxml+xml"]

    // MARK: Private Instance Methods

    private func _dump(_ container: MXLContainer,
                       _ file: FileWrapper) throws {
        guard let rootFile = container.rootFiles.first
        else { throw MXLParser.Error.noRootFileFound }

        if let mediaType = rootFile.mediaType {
            guard Self.mediaTypes.contains(mediaType)
            else { throw MXLParser.Error.invalidRootFileMediaType(mediaType) }
        }

        emit()
        emit(2, _format(rootFile))

        let realFile = try file.findFile([rootFile.fullPath])
        let data = try realFile.contentsOfRegularFile()
        let entity = try MXLParser(data).parse()

        _dump(entity)
    }

    private func _dump(_ entity: MXLEntity) {
        switch entity {
            // case let .opus(opus):
            //     _dump(opus)

        case let .scorePartwise(score):
            _dump(score)

            // case let .scoreTimewise(score):
            //     _dump(score)

        default:
            fatalError("Not yet implemented")
        }
    }

    private func _dump(_ item: MXLMusicItem) {
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

        emit(8, line)
    }

    private func _dump(_ measure: MXLMeasurePartwise) {
        let items = measure.items

        var header = "Measure "

        header += format(measure.number,
                         quoteAndEscape: false)
        header += spacer()
        header += format(items.count, "item")

        emit()
        emit(6, header)

        if !items.isEmpty {
            emit()

            for item in items {
                _dump(item)
            }
        }
    }

    private func _dump(_ movementNumber: String?,
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
        emit(4, line)
    }

    private func _dump(_ partList: MXLPartList) {
        let scoreParts = partList.scoreParts

        var header = "Part-list"

        header += spacer()
        header += format(scoreParts.count, "score-part")

        emit()
        emit(4, header)
        emit()

        for scorePart in scoreParts {
            _dump(scorePart)
        }
    }

    private func _dump(_ part: MXLPartPartwise) {
        let measures = part.measures

        var header = "Part "

        header += format(part.id)
        header += spacer()
        header += format(measures.count, "measure")

        emit()
        emit(4, header)

        for measure in measures {
            _dump(measure)
        }
    }

    private func _dump(_ scorePart: MXLScorePart) {
        var line = "Score-part "

        line += format(scorePart.id)
        line += spacer()
        line += format(scorePart.partName)

        emit(6, line)
    }

    private func _dump(_ score: MXLScorePartwise) {
        let parts = score.parts

        var header = "Score"

        header += spacer()
        header += "Partwise"
        header += spacer()
        header += format(parts.count, "part")

        emit()
        emit(2, header)

        if let work = score.work {
            _dump(work)
        }

        _dump(score.movementNumber,
              score.movementTitle)

        _dump(score.partList)

        for part in parts {
            _dump(part)
        }
    }

    private func _dump(_ work: MXLWork) {
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
        emit(4, line)
    }

    private func _format(_ alter: Float?) -> String? {
        guard let alter
        else { return nil }

        switch Int(alter) {
        case -2:
            return "𝄫"

        case -1:
            return "♭"

        case 1:
            return "♯"

        case 2:
            return "𝄪"

        default:
            return nil
        }
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
        var result = pitch.step

        if let alter = _format(pitch.alter) {
            result += alter
        }

        result += format(pitch.octave)

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
