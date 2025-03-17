import Foundation

enum Organizer {
    /// Sorts clippings alphabetically based on their clipping
    static func sortAlphabetically(clippings: [Clipping]) -> [Clipping] {
        clippings.sorted { $0.clipping < $1.clipping }
    }

    /// Reverses the clipping of each clipping
    static func reverseClippings(in clippings: [Clipping]) -> [Clipping] {
        clippings.map {
            Clipping(
                source: $0.source,
                meta: $0.meta,
                clipping: String($0.clipping.reversed())
            )
        }
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
}
