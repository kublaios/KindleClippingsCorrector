import Foundation

enum FileReader {
    static func readFromFile(at url: URL) throws -> [String] {
        readLines(
            from: try readFile(at: url)
        )
    }

    static func readFile(at url: URL) throws -> String {
        try String(contentsOf: url, encoding: .utf8)
    }

    static func readLines(from input: String) -> [String] {
        input.split(separator: "\n", omittingEmptySubsequences: false)
            .map(String.init)
    }
}

