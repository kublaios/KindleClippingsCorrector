import Foundation

enum Corrector {
    static func correct(
        clippings: [Clipping],
        threshold: Int,
        denylist: [String]
    ) -> [Clipping] {
        let withoutDuplicates = removeDuplicates(from: clippings)
        let aboveThreshold = removeClippingsBelowWordCountThreshold(from: withoutDuplicates, threshold: threshold)
        let withoutDenylist = removeWithDenylist(from: aboveThreshold, denylist: denylist)
        // TODO: Add merging similar clippings
        return withoutDenylist
    }

    /// Removes only if `clipping` attribute is duplicated
    static func removeDuplicates(from clippings: [Clipping]) -> [Clipping] {
        var uniqueClippings: [Clipping] = []
        var clippingSet: Set<String> = []
        for clipping in clippings {
            guard !clippingSet.contains(clipping.clipping) else {
                continue
            }
            clippingSet.insert(clipping.clipping)
            uniqueClippings.append(clipping)
        }
        return uniqueClippings
    }

    /// Removes clippings with word count below threshold
    static func removeClippingsBelowWordCountThreshold(from clippings: [Clipping], threshold: Int) -> [Clipping] {
        clippings.filter { clipping in
            clipping.clipping.split(separator: " ").count >= threshold
        }
    }

    /// Removes clippings that contain any of the denylisted words
    static func removeWithDenylist(from clippings: [Clipping], denylist: [String]) -> [Clipping] {
        clippings.filter { clipping in
            !denylist.contains { deny in
                clipping.clipping.contains(deny)
            }
        }
    }
}
