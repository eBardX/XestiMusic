// © 2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiABC

@Suite
struct StringExtensionsTests {
    @Test
    func normalize() async throws {
        #expect("  abc  ".normalizedABCWhitespace() == "abc")
        #expect("  x  y zz    y".normalizedABCWhitespace() == "x y zz y")
    }
}
