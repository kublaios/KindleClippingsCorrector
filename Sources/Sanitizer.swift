import Foundation

enum Sanitizer {
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

    /// Merges each clipping with the next as long as the next clipping
    /// contains the current clipping.
    /// **Note:** This function assumes that the clippings are sorted by length
    static func mergeSimilarClippings(in clippings: [Clipping]) -> [Clipping] {
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
