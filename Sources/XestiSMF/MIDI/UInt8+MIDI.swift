// © 2025 John Gary Pusey (see LICENSE.md)

extension UInt8 {

    // MARK: Public Instance Propert$

    public var isMIDIDataByte: Bool {
        (0...0x7f).contains(self)
    }

    public var isMIDIStatusByte: Bool {
        (0x80...0xff).contains(self)
    }
}
