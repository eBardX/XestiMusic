// © 2025 John Gary Pusey (see LICENSE.md)

extension UInt8 {

    // MARK: Public Instance Properties

    public var isMetaEventStatusByte: Bool {
        self == 0xff
    }

    public var isMIDIEventStatusByte: Bool {
        [0x80, 0x90, 0xa0, 0xb0, 0xc0, 0xd0, 0xe0].contains(self & 0xf0)
    }

    public var isSysExEventStatusByte: Bool {
        [0xf0, 0xf7].contains(self)
    }
}
