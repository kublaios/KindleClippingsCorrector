import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct MapperTests {
    @Test
    func mapsLinesToClippings() {
        let lines = [
            "The Gunslinger (Stephen King)",
            "- Your Highlight on page 29 | Location 279-280 | Added on Tuesday, February 4, 2025 10:10:00 PM",
            "",
            "“Spark-a-dark, where’s my sire? Will I lay me? Will I stay me? Bless this camp with fire.”",
            "==========",
            "The Gunslinger (Stephen King)",
            "- Your Highlight on page 113 | Location 1381-1381 | Added on Tuesday, February 4, 2025 10:15:54 PM",
            "",
            "Was there ever a trap to match the trap of love?",
            "==========",
        ]
        let expected = [
            Clipping(
                source: "The Gunslinger (Stephen King)",
                meta: "- Your Highlight on page 29 | Location 279-280 | Added on Tuesday, February 4, 2025 10:10:00 PM",
                clipping: "“Spark-a-dark, where’s my sire? Will I lay me? Will I stay me? Bless this camp with fire.”"
            ),
            Clipping(
                source: "The Gunslinger (Stephen King)",
                meta: "- Your Highlight on page 113 | Location 1381-1381 | Added on Tuesday, February 4, 2025 10:15:54 PM",
                clipping: "Was there ever a trap to match the trap of love?"
            ),
        ]
        let result = Mapper.mapLinesToClippings(lines: lines)
        #expect(result == expected)
    }
}
