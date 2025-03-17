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
        let sorted = Organizer.sortAlphabetically(clippings: withoutDenylist)
        var grouped = Organizer.groupBySource(clippings: sorted)
        for (source, clippings) in grouped {
            let merged = Sanitizer.mergeSimilarClippings(in: clippings)
            grouped[source] = merged
        }
        let clippings = grouped.values.flatMap { $0 }
        return clippings
    }
}
