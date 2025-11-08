// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

let args = Array(CommandLine.arguments.dropFirst())
let stdio = StandardIO()
let dumper = MusicDumper(stdio)

guard !args.isEmpty
else { stdio.writeError("Usage: mdump <file-path>…"); exit(1)}

for arg in args {
    try dumper.dump(URL(fileURLWithPath: arg).absoluteURL)
}
