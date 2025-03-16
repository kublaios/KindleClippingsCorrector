import Foundation

enum Mapper {
    static func mapLinesToClippings(lines: [String]) -> [Clipping] {
        var clippings: [Clipping] = []
        var currentClipping: Clipping?
        for line in lines {
            guard currentClipping != nil else {
                currentClipping = Clipping(source: line, meta: "", clipping: "")
                continue
            }
            guard !line.isEmpty else {
                continue
            }
            if currentClipping?.meta.isEmpty == true {
                currentClipping?.meta = line
            } else if currentClipping?.clipping.isEmpty == true {
                currentClipping?.clipping = line
            } else if line == "==========" {
                clippings.append(currentClipping!)
                currentClipping = nil
            }
        }
        return clippings
    }
}
