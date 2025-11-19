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

        let tunebook = try ABCParser().parse(readFile(fileURL))

        _dump(2, tunebook)

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

    private func _dump(_ indent: Int,
                       _ tunebook: ABCTunebook) {
    }
}
