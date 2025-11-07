// © 2025 John Gary Pusey (see LICENSE.md)

@testable import XestiSMF
import Testing

@Suite
struct SMPTETimeTests {
    @Test
    func `init`() {
        let time = SMPTETime(frameRate: .fps24,
                             hour: 12,
                             minute: 34,
                             second: 56,
                             frame: 12,
                             fraction: 34)

        #expect(time != nil)

        if let time {
            #expect(time.frameRate == .fps24)
            #expect(time.hour == 12)
            #expect(time.minute == 34)
            #expect(time.second == 56)
            #expect(time.frame == 12)
            #expect(time.fraction == 34)
        }
    }
}
