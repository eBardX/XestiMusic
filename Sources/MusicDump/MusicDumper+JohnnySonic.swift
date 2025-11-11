// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiDKM
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpJohnnySonic(_ fileURL: URL) throws {
        var banner = "Dump of JohnnySonic Score File "

        banner += format(fileURL.path)

        emit()
        emit(banner)

        // let score = try DKMParser().parse(readFile(fileURL))

        // _dump(score)

        emit()
    }

    // MARK: Private Type Properties

    private static let commands: [DKMCommand: String] = [.chorus: "Chorus",
                                                         .clip: "Clip",
                                                         .comment: "Comment",
                                                         .compress: "Compress",
                                                         .dynamics: "Dynamics",
                                                         .end: "End",
                                                         .exclude: "Exclude",
                                                         .filter: "Filter",
                                                         .flange: "Flange",
                                                         .freqBandAnalyze: "Frequency band analyze",
                                                         .geq: "Graphic EQ",
                                                         .haas: "Haas",
                                                         .include: "Include",
                                                         .levels: "Levels",
                                                         .mix: "Mix",
                                                         .pitches: "Pitches",
                                                         .pulse: "Pulse",
                                                         .reverb: "Reverb",
                                                         .screenOut: "Screen out",
                                                         .sendBack: "Send back",
                                                         .showBuffer: "Show buffer",
                                                         .soundFileName: "Sound file name",
                                                         .stats: "Stats",
                                                         .tempo: "Tempo",
                                                         .tuning: "Tuning",
                                                         .vocode: "Vocode"]

    // MARK: Private Instance Methods

    private func _dump(_ entry: DKMEntry) {
        var line = _format(entry.command)

        if !entry.arguments.isEmpty {
            line += spacer()
            line += _format(entry.arguments)
        }

        emit(4, line)
    }

    private func _dump(_ score: DKMScore) {
        let entries = score.entries

        var header = "Score"

        header += spacer()
        header += format(entries.count,
                         "entry",
                         plural: "entries")

        emit()
        emit(2, header)

        if !entries.isEmpty {
            emit()

            for entry in entries {
                _dump(entry)
            }
        }
    }

    private func _format(_ argument: DKMArgument) -> String {
        switch argument {
        case let .double(value):
            format(value)

        case let .string(value):
            format(value)
        }
    }

    private func _format(_ arguments: [DKMArgument]) -> String {
        arguments.map { _format($0) }.joined(separator: spacer())
    }

    private func _format(_ command: DKMCommand) -> String {
        Self.commands[command] ?? "Unknown \(command.rawValue)"
    }
}
