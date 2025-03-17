import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct FileWriterTests {
    @Test
    func writesClippingsToFile() throws {
        let clippings = [
            Clipping(source: .init("Source 1"), meta: "Meta 1", clipping: "Clipping 1"),
            Clipping(source: .init("Source 2"), meta: "Meta 2", clipping: "Clipping 2"),
            Clipping(source: .init("Source 3"), meta: "Meta 3", clipping: "Clipping 3"),
        ]
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            #expect(Bool(false))
            return
        }

        let fileURL = cachesDir.appendingPathComponent("test-writes-file.txt")
        try FileWriter.write(clippings: clippings, to: fileURL)
        let result = try FileReader.readFile(at: fileURL)
        let expected =
            """
            Source 1
            Meta 1

            Clipping 1
            ==========
            Source 2
            Meta 2

            Clipping 2
            ==========
            Source 3
            Meta 3

            Clipping 3
            ==========
            """
        #expect(result == expected)
        try FileManager.default.removeItem(at: fileURL)
    }
}

enum FileWriter {
    static func write(clippings: [Clipping], to fileURL: URL) throws {
        let contents = clippings.map {
            """
            \($0.source.name)
            \($0.meta)

            \($0.clipping)
            ==========
            """
        }.joined(separator: "\n")
        try contents.write(to: fileURL, atomically: false, encoding: .utf8)
    }
}
