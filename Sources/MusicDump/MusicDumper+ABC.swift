// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiABC
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpABC(_ fileURL: URL) throws {
        var banner = "Dump of ABC File "

        banner += format(fileURL.path)

        emit()
        emit(banner)

        var parser = try ABCParser(readFile(fileURL))

        let tunes = try parser.parse()

        _dump(tunes)

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

    private func _dump(_ tunes: [ABCTune]) {
    }
}
