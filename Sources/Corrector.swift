import Foundation

enum Corrector {
    static func correct(
        clippings: [Clipping],
        threshold: Int,
        denylist: [String]
    ) -> [Clipping] {
        let withoutDuplicates = Sanitizer.removeDuplicates(from: clippings)
        let aboveThreshold = Sanitizer.removeClippingsBelowWordCountThreshold(from: withoutDuplicates, threshold: threshold)
        let withoutDenylist = Sanitizer.removeWithDenylist(from: aboveThreshold, denylist: denylist)
        let grouped = Organizer.groupBySource(clippings: withoutDenylist)
        var result: [Clipping] = []
        for clippings in grouped.values {
            result += mergeSimilarClippings(in: clippings)
        }
        return result
    }

    private static func mergeSimilarClippings(in clippings: [Clipping]) -> [Clipping] {
        let reversed = Organizer.reverseClippings(in: clippings)
        let reversedSorted = Organizer.sortAlphabetically(clippings: reversed)
        let reversedMerged = Sanitizer.mergeSimilarClippings(in: reversedSorted)
        let normalized = Organizer.reverseClippings(in: reversedMerged)
        let normalizedSorted = Organizer.sortAlphabetically(clippings: normalized)
        let normalizedMerged = Sanitizer.mergeSimilarClippings(in: normalizedSorted)
        return normalizedMerged
    }
}
