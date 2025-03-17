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
        let sorted = sortAlphabetically(clippings: withoutDenylist)
        var grouped = groupBySource(clippings: sorted)
        for (source, clippings) in grouped {
            let merged = mergeSimilarClippings(clippings: clippings)
            grouped[source] = merged
        }
        let clippings = grouped.values.flatMap { $0 }
        return clippings
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

    /// Sorts clippings alphabetically based on their clipping
    static func sortAlphabetically(clippings: [Clipping]) -> [Clipping] {
        clippings.sorted { $0.clipping < $1.clipping }
    }

    /// Groups clippings by their source
    static func groupBySource(clippings: [Clipping]) -> [Source: [Clipping]] {
        var groupedClippings: [Source: [Clipping]] = [:]
        for clipping in clippings {
            if groupedClippings[clipping.source] == nil {
                groupedClippings[clipping.source] = [clipping]
            } else {
                groupedClippings[clipping.source]?.append(clipping)
            }
        }
        return groupedClippings
    }

    /// Merges each clipping with the next as long as the next clipping
    /// contains the current clipping.
    /// **Note:** This function assumes that the clippings are sorted by length
    static func mergeSimilarClippings(clippings: [Clipping]) -> [Clipping] {
        var lastClipping: Clipping?
        var mergedClippings: [Clipping] = []
        for currentClipping in clippings {
            guard lastClipping != nil else {
                lastClipping = currentClipping
                continue
            }
            if currentClipping.clipping.contains(lastClipping!.clipping) {
                lastClipping = currentClipping
            } else {
                mergedClippings.append(lastClipping!)
                lastClipping = currentClipping
            }
        }
        // Don't forget to append the last clipping
        if let lastClipping {
            mergedClippings.append(lastClipping)
        }
        return mergedClippings
    }
}
