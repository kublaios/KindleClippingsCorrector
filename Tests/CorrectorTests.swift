import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct CorrectorTests {
    @Test
    func removesDuplicateClippings() {
        let clippings = [
            Clipping(source: "Source 1", meta: "Meta 1", clipping: "Clipping"),
            Clipping(source: "Source 2", meta: "Meta 2", clipping: "Clipping"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Clipping"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Clipping 2"),
        ]
        let expected = [
            Clipping(source: "Source 1", meta: "Meta 1", clipping: "Clipping"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Clipping 2"),
        ]
        let result = Corrector.removeDuplicates(from: clippings)
        #expect(result == expected)
    }

    @Test
    func removesWhenClippingWordCountIsBelowThreshold() {
        let clippings = [
            Clipping(source: "Source 1", meta: "Meta 1", clipping: "One"),
            Clipping(source: "Source 2", meta: "Meta 2", clipping: "One Two"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "One Two Three Four"),
        ]
        let expected = [
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "One Two Three Four"),
        ]
        let result = Corrector.removeClippingsBelowWordCountThreshold(from: clippings, threshold: 3)
        #expect(result == expected)
    }

    @Test
    func removesWithDenylist() {
        let clippings = [
            Clipping(source: "Source 1", meta: "Meta 1", clipping: "One"),
            Clipping(source: "Source 2", meta: "Meta 2", clipping: "Two"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Three"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Four"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "One Two Three"),
        ]
        let denylist = ["Two", "Four"]
        let expected = [
            Clipping(source: "Source 1", meta: "Meta 1", clipping: "One"),
            Clipping(source: "Source 3", meta: "Meta 3", clipping: "Three"),
        ]
        let result = Corrector.removeWithDenylist(from: clippings, denylist: denylist)
        #expect(result == expected)
    }
}
