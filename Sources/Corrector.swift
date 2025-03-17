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

    static func removeWithDenylist(from clippings: [Clipping], denylist: [String]) -> [Clipping] {
        // TODO: Do not require exact match, use contains instead
        clippings.filter { clipping in
            !denylist.contains(clipping.clipping)
        }
    }
}
