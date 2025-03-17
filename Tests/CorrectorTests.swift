import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct CorrectorTests {
    @Test
    func testCorrectsClippings() {
        let source1 = Source("Source 1")
        let source2 = Source("Source 2")
        let source3 = Source("Source 3")
        let clippings = [
            Clipping(source: source1, meta: "Meta 1", clipping: "A B"),
            Clipping(source: source2, meta: "Meta 2", clipping: "B C"),
            Clipping(source: source2, meta: "Meta 3", clipping: "B C D"),
            Clipping(source: source2, meta: "Meta 3", clipping: "C D E"),
            Clipping(source: source2, meta: "Meta 4", clipping: "B C D E"),
            Clipping(source: source3, meta: "Meta 5", clipping: "Clipping clipping"),
            Clipping(source: source3, meta: "Meta 6", clipping: "Clipping clipping 2"),
            Clipping(source: source3, meta: "Meta 7", clipping: "Clipping"),
        ]
        let expected = [
            Clipping(source: source1, meta: "Meta 1", clipping: "A B"),
            Clipping(source: source2, meta: "Meta 4", clipping: "B C D E"),
        ]
        let result = Corrector.correct(
            clippings: clippings,
            threshold: 1,
            denylist: ["lippin"]
        )
        #expect(result == expected)
    }
}
