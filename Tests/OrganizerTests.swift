import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct OrganizerTests {
    @Test
    func sortsAlphabetically() {
        let clippings = [
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Three"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "Two"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Four"),
        ]
        let expected = [
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Four"),
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "One Two Three"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Three"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "Two"),
        ]
        let result = Organizer.sortAlphabetically(clippings: clippings)
        #expect(result == expected)
    }

    @Test
    func reversesClippings() {
        let clippings = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "One Two Three"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "One"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Three"),
        ]
        let expected = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "eerhT owT enO"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "enO"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "eerhT"),
        ]
        let result = Organizer.reverseClippings(in: clippings)
        #expect(result == expected)
    }

    @Test
    func groupsBySource() {
        let source1 = Source("Source 1")
        let source2 = Source("Source 2")
        let source3 = Source("Source 3")
        let clippings = [
            Clipping(source: source1, meta: "Meta 1", clipping: "One"),
            Clipping(source: source2, meta: "Meta 2", clipping: "Two"),
            Clipping(source: source3, meta: "Meta 3", clipping: "Three"),
            Clipping(source: source2, meta: "Meta 3", clipping: "Four"),
            Clipping(source: source1, meta: "Meta 3", clipping: "One Two Three"),
        ]
        let expected = [
            source1: [
                Clipping(source: source1, meta: "Meta 1", clipping: "One"),
                Clipping(source: source1, meta: "Meta 3", clipping: "One Two Three"),
            ],
            source2: [
                Clipping(source: source2, meta: "Meta 2", clipping: "Two"),
                Clipping(source: source2, meta: "Meta 3", clipping: "Four"),
            ],
            source3: [
                Clipping(source: source3, meta: "Meta 3", clipping: "Three"),
            ],
        ]
        let result = Organizer.groupBySource(clippings: clippings)
        #expect(result == expected)
    }
}
