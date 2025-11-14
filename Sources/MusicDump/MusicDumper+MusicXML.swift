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

        let entity = try MXLParser().parse(readFile(fileURL),
                                           compressed: compressed)

        _dump(2, entity)

        emit()
    }

    // MARK: Private Type Properties

    private static let mediaTypes = ["application/musicxml+xml",
                                     "application/vnd.recordare.musicxml+xml"]

    // MARK: Private Instance Methods

    private func _dump(_ indent: Int,
                       _ container: MXLContainer) {
        let rootFiles = container.rootFiles

        var header = "Container"

        header += spacer()
        header += format(rootFiles.count, "root file")

        emit()
        emit(indent, header)
        emit()

        for (index, rootFile) in rootFiles.enumerated() {
            _dump(indent + 2, rootFile, index)
        }
    }

    private func _dump(_ indent: Int,
                       _ container: MXLContainer,
                       _ file: FileWrapper) throws {
        guard let rootFile = container.rootFiles.first
        else { throw MXLParser.Error.noRootFileFound }

        guard Self.mediaTypes.contains(rootFile.mediaType)
        else { throw MXLParser.Error.invalidRootFileMediaType(rootFile.mediaType) }

        emit()
        emit(indent, _format(rootFile))

        let realFile = try file.findFile([rootFile.fullPath])
        let data = try realFile.contentsOfRegularFile()
        let entity = try MXLParser().parse(data,
                                           compressed: false)

        _dump(indent + 2, entity)
    }

    private func _dump(_ indent: Int,
                       _ entity: MXLEntity) {
        switch entity {
        case let .container(container):
            _dump(indent, container)

        case let .opus(opus):
            _dump(indent, opus)

        case let .scorePartwise(score):
            _dump(indent, score)

        case let .scoreTimewise(score):
            _dump(indent, score)

        case let .sounds(sounds):
            _dump(indent, sounds)
        }
    }

    private func _dump(_ indent: Int,
                       _ item: MXLMusicItem) {
        var line = ""

        switch item {
        case let .attributes(divisions):
            line += "Divisions"
            line += spacer()
            line += format(divisions)

        case let .backup(duration):
            line += "Backup"
            line += spacer()
            line += format(duration)

        case let .forward(duration):
            line += "Forward"
            line += spacer()
            line += format(duration)

        case let .note(note):
            line += "Note"
            line += spacer()
            line += _format(note)

        case let .sound(tempo):
            line += "Tempo"
            line += spacer()
            line += format(Int(tempo))
            line += " bpm"
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ item: MXLOpus.Item) {
        switch item {
        case let .opus(opus):
            _dump(indent, opus)

        case let .opusLink(link):
            emit(indent,
                 "Opus link" + spacer() + format(link))

        case let .score(link):
            emit(indent,
                 "Score" + spacer() + format(link))
        }
    }

    private func _dump(_ indent: Int,
                       _ measure: MXLMeasurePW) {
        let items = measure.items

        var header = "Measure "

        header += measure.number
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
                       _ measure: MXLMeasureTW) {
        let parts = measure.parts

        var header = "Measure "

        header += measure.number
        header += spacer()
        header += format(parts.count, "part")

        emit()
        emit(indent, header)

        for part in parts {
            _dump(indent + 2, part)
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
                       _ opus: MXLOpus) {
        let items = opus.items

        var header = "Opus"

        header += spacer()
        header += format(items.count, "item")

        emit()
        emit(indent, header)

        var line = "Title"

        line += spacer()
        line += format(opus.title)

        emit()
        emit(indent + 2, line)

        for item in items {
            _dump(indent + 2, item)
        }
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
                       _ part: MXLPartPW) {
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
                       _ part: MXLPartTW) {
        let items = part.items

        var header = "Part "

        header += format(part.id)
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
                       _ rootFile: MXLRootFile,
                       _ index: Int) {
        var line = "Root file #"

        line += format(index + 1)
        line += spacer()
        line += format(rootFile.fullPath)
        line += spacer()
        line += rootFile.mediaType

        emit(indent, line)
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
                       _ score: MXLScorePW) {
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
                       _ score: MXLScoreTW) {
        let measures = score.measures

        var header = "Score"

        header += spacer()
        header += "Timewise"
        header += spacer()
        header += format(measures.count, "measure")

        emit()
        emit(indent, header)

        if let work = score.work {
            _dump(indent + 2, work)
        }

        _dump(indent + 2,
              score.movementNumber,
              score.movementTitle)

        _dump(indent + 2, score.partList)

        for measure in measures {
            _dump(indent + 2, measure)
        }
    }

    private func _dump(_ indent: Int,
                       _ sound: MXLStandardSound,
                       _ index: Int) {
        var line = "Sound #"

        line += format(index + 1)
        line += spacer()
        line += sound.id

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ sounds: [MXLStandardSound]) {
        var header = "Sounds"

        header += spacer()
        header += format(sounds.count, "sound")

        emit()
        emit(indent, header)
        emit()

        for (index, sound) in sounds.enumerated() {
            _dump(indent + 2, sound, index)
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

        if note.chord {
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
        var result = pitch.step.rawValue

        result += spacer()
        result += format(pitch.alter)
        result += spacer()
        result += format(pitch.octave)

        return result
    }

    private func _format(_ rootFile: MXLRootFile) -> String {
        var line = "Root file"

        line += spacer()
        line += format(rootFile.fullPath)
        line += spacer()
        line += rootFile.mediaType

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
            _format(pitch)

        case .rest:
            "Rest"

        case .unpitched:
            "Unpitched"
        }
    }
}
