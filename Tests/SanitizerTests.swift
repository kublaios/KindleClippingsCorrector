import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct SanitizerTests {
    @Test
    func removesDuplicateClippings() {
        let clippings = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "Clipping"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "Clipping"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Clipping"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Clipping 2"),
        ]
        let expected = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "Clipping"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Clipping 2"),
        ]
        let result = Sanitizer.removeDuplicates(from: clippings)
        #expect(result == expected)
    }

    @Test
    func removesWhenClippingWordCountIsBelowThreshold() {
        let clippings = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "One Two"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three Four"),
        ]
        let expected = [
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three Four"),
        ]
        let result = Sanitizer.removeClippingsBelowWordCountThreshold(from: clippings, threshold: 3)
        #expect(result == expected)
    }

    @Test
    func removesWithDenylist() {
        let clippings = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "Two"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Three"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Four"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three"),
        ]
        let denylist = ["Two", "Four"]
        let expected = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Three"),
        ]
        let result = Sanitizer.removeWithDenylist(from: clippings, denylist: denylist)
        #expect(result == expected)
    }

    @Test
    func mergesSimilarClippings() {
        let source = Source("Source")
        let clippings = [
            Clipping(source: source, meta: "Meta 1", clipping: "Some text"),
            Clipping(source: source, meta: "Meta 2", clipping: "Some more text"),
            Clipping(source: source, meta: "Meta 3", clipping: "done. Some more text"),
            Clipping(source: source, meta: "Meta 4", clipping: "Some more text was done"),
            Clipping(source: source, meta: "Meta 5", clipping: "done. Some more text was done then"),
        ]
        let expected = [
            Clipping(source: source, meta: "Meta 1", clipping: "Some text"),
            Clipping(source: source, meta: "Meta 3", clipping: "done. Some more text"),
            Clipping(source: source, meta: "Meta 5", clipping: "done. Some more text was done then"),
        ]
        let result = Sanitizer.mergeSimilarClippings(in: clippings)
        #expect(result == expected)
    }
}
