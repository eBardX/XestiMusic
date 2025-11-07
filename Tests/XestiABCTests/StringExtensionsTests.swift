// © 2025 John Gary Pusey (see LICENSE.md)

@testable import XestiABC
import Testing

@Suite
struct StringExtensionsTests {
    @Test
    func normalize() async throws {
        #expect("  abc  ".normalizedABCWhitespace() == "abc")
        #expect("  x  y zz    y".normalizedABCWhitespace() == "x y zz y")
    }
}
