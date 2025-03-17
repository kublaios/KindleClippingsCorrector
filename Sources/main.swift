// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// TODO: Convert to a command line tool
let currentDirectory = FileManager.default.currentDirectoryPath
print("Working directory: \(currentDirectory)")
let fileName = "clippings.txt"
print("Looking for \(fileName) in the current directory...")
let clippingsFileURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent("clippings.txt")
if !FileManager.default.fileExists(atPath: clippingsFileURL.path) {
    print(fileName + " not found in the current directory.")
    exit(1)
} else {
    print("Found \(fileName) in the current directory.")
}

do {
    print("Reading clippings from clippings.txt...")
    let lines = try FileReader.readFromFile(at: clippingsFileURL)
    print("Read \(lines.count) lines from clippings.txt.")
    print("Mapping lines to clippings...")
    let clippings = Mapper.mapLinesToClippings(lines: lines)
    print("Mapped \(clippings.count) clippings from \(lines.count) lines.")
    print("Correcting clippings...")
    let threshold = 3
    let denylist = ["You have reached the clipping limit for this item" ]
    print("Clippings with less than \(threshold) words and in the denylist will be removed.")
    print("Denylist: \(denylist)")
    let correctedClippings = Corrector.correct(
        clippings: clippings,
        threshold: threshold,
        denylist: denylist
    )
    print("Corrected \(clippings.count) clippings to \(correctedClippings.count) clippings.")
    let newFileName = "corrected-clippings.txt"
    print("Writing corrected clippings to \(newFileName)...")
    let newFileURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent(newFileName)
    try FileWriter.write(clippings: correctedClippings, to: newFileURL)
    print("Wrote \(correctedClippings.count) clippings to \(newFileName).")
    exit(0)
} catch {
    print("An error occurred: \(error)")
    exit(1)
}

