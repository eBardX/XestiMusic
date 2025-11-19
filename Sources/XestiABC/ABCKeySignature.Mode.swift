// © 2025 John Gary Pusey (see LICENSE.md)

extension ABCKeySignature {
    public enum Mode {
        case aeolian
        case dorian
        case explicit
        case highlandPipes
        case ionian
        case locrian
        case lydian
        case major
        case minor
        case mixolydian
        case phrygian
    }
}

// MARK: -

extension ABCKeySignature.Mode {

    // MARK: Public Initializers

    public init?(name: String) {
        guard let value = Self.nameMap[name.lowercased()]
        else { return nil }

        self = value
    }

    // MARK: Private Type Properties

    private static let nameMap: [String: Self] = ["": .major,
                                                  "aeo": .aeolian,
                                                  "aeol": .aeolian,
                                                  "aeoli": .aeolian,
                                                  "aeolia": .aeolian,
                                                  "aeolian": .aeolian,
                                                  "dor": .dorian,
                                                  "dori": .dorian,
                                                  "doria": .dorian,
                                                  "dorian": .dorian,
                                                  "exp": .explicit,
                                                  "hp": .highlandPipes,
                                                  "ion": .ionian,
                                                  "ioni": .ionian,
                                                  "ionia": .ionian,
                                                  "ionian": .ionian,
                                                  "loc": .locrian,
                                                  "locr": .locrian,
                                                  "locri": .locrian,
                                                  "locria": .locrian,
                                                  "locrian": .locrian,
                                                  "lyd": .lydian,
                                                  "lydi": .lydian,
                                                  "lydia": .lydian,
                                                  "lydian": .lydian,
                                                  "m": .minor,
                                                  "maj": .major,
                                                  "majo": .major,
                                                  "major": .major,
                                                  "min": .minor,
                                                  "mino": .minor,
                                                  "minor": .minor,
                                                  "mix": .mixolydian,
                                                  "mixo": .mixolydian,
                                                  "mixol": .mixolydian,
                                                  "mixoly": .mixolydian,
                                                  "mixolyd": .mixolydian,
                                                  "mixolydi": .mixolydian,
                                                  "mixolydia": .mixolydian,
                                                  "mixolydian": .mixolydian,
                                                  "phr": .phrygian,
                                                  "phry": .phrygian,
                                                  "phryg": .phrygian,
                                                  "phrygi": .phrygian,
                                                  "phrygia": .phrygian,
                                                  "phrygian": .phrygian]
}

// MARK: - Sendable

extension ABCKeySignature.Mode: Sendable {
}
