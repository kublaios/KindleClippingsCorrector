import Foundation

enum FileWriter {
    static func write(clippings: [Clipping], to fileURL: URL) throws {
        let contents = clippings.map {
            """
            \($0.source)
            \($0.meta)

            \($0.clipping)
            ==========
            """
        }.joined(separator: "\n")
        try contents.write(to: fileURL, atomically: false, encoding: .utf8)
    }
}
