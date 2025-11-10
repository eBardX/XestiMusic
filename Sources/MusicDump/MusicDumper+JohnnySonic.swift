// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiDKM
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpJohnnySonic(_ fileURL: URL) throws {
        emit()
        emit("Dump of JohnnySonic Score File “\(fileURL.path)”")

        // var parser = try DKMParser(readFile(fileURL))

        // let entity = try parser.parse()

        // _dump(entity)

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

}
