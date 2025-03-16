import Foundation
import Testing

@testable import KindleClippingsCorrector

private struct FileReaderTests {
    private let input =
        """
        Line 0
        Line 1

        Line 2


        """
    @Test
    func readsPlainTextInput() {
        let expected = ["Line 0", "Line 1", "", "Line 2", "", ""]
        let result = FileReader.readLines(from: input)
        #expect(result == expected)
    }

    @Test
    func readsFile() throws {
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            #expect(Bool(false))
            return
        }

        let fileURL = cachesDir.appendingPathComponent("test-reads-file.txt")
        try input.write(to: fileURL, atomically: false, encoding: .utf8)
        let result = try FileReader.readFile(at: fileURL)
        #expect(result == input)
        try FileManager.default.removeItem(at: fileURL)
    }

    @Test
    func readsFromFile() throws {
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            #expect(Bool(false))
            return
        }

        let fileURL = cachesDir.appendingPathComponent("test-reads-from-file.txt")
        try input.write(to: fileURL, atomically: false, encoding: .utf8)
        let expected = ["Line 0", "Line 1", "", "Line 2", "", ""]
        let result = try FileReader.readFromFile(at: fileURL)
        #expect(result == expected)
        try FileManager.default.removeItem(at: fileURL)
    }
}
