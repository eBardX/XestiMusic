// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiGMN
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpGuido(_ fileURL: URL) throws {
        emit()
        emit("Dump of Guido Score File “\(fileURL.path)”")

        let score = try GMNParser().parse(readFile(fileURL))

        _dump(score)

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

    private func _dump(_ score: GMNScore) {
    }
}
