// © 2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSMF

@Suite
struct MIDIChannelTests {
    @Test
    func init_bytesValue() {
        let chan = MIDIChannel([0])

        #expect(chan != nil)

        if let chan {
            #expect(chan.uintValue == 1)
            #expect(chan.bytesValue == [0])
        }
    }

    @Test
    func init_intValue() {
    }

    @Test
    func isValid() {
        #expect(MIDIChannel.isValid(1))
        #expect(MIDIChannel.isValid(8))
        #expect(MIDIChannel.isValid(16))
        #expect(!MIDIChannel.isValid(0))
        #expect(!MIDIChannel.isValid(17))
        #expect(!MIDIChannel.isValid(9_999_999))
    }
}
