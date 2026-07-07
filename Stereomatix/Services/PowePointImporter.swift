import Foundation
import AppKit

struct PowerPointImportResult {
    let stereoPairs: [StereoPair]
}

struct PowerPointImporter {

    static func importPowerPoints(urls: [URL]) -> PowerPointImportResult {
        var allPairs: [StereoPair] = []

        for pptxURL in urls {
            allPairs.append(contentsOf: importSinglePowerPoint(url: pptxURL))
        }

        return PowerPointImportResult(stereoPairs: allPairs)
    }

    private static func importSinglePowerPoint(url: URL) -> [StereoPair] {

        let tempFolder = FileManager.default.temporaryDirectory
            .appendingPathComponent("Stereomatix-\(UUID().uuidString)")

        try? FileManager.default.createDirectory(
            at: tempFolder,
            withIntermediateDirectories: true
        )

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-q", url.path, "-d", tempFolder.path]

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return []
        }

        let slidesFolder = tempFolder
            .appendingPathComponent("ppt")
            .appendingPathComponent("slides")

        guard let slideFiles = try? FileManager.default.contentsOfDirectory(
            at: slidesFolder,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        let sortedSlides = slideFiles
            .filter { $0.pathExtension == "xml" && $0.lastPathComponent.hasPrefix("slide") }
            .sorted { slideNumber($0) < slideNumber($1) }

        var pairs: [StereoPair] = []

        for slideURL in sortedSlides {
            let imageURLs = imageURLsForSlide(slideURL: slideURL, slidesFolder: slidesFolder)

            var index = 0

            while index < imageURLs.count - 1 {
                guard
                    let left = makePhotoCandidate(from: imageURLs[index]),
                    let right = makePhotoCandidate(from: imageURLs[index + 1])
                else {
                    index += 2
                    continue
                }

                pairs.append(
                    StereoPair(
                        leftPhoto: left,
                        rightPhoto: right,
                        timeDifference: 0
                    )
                )

                index += 2
            }
        }

        return pairs
    }

    private static func imageURLsForSlide(slideURL: URL, slidesFolder: URL) -> [URL] {

        let relsURL = slidesFolder
            .appendingPathComponent("_rels")
            .appendingPathComponent(slideURL.lastPathComponent + ".rels")

        guard
            let slideData = try? Data(contentsOf: slideURL),
            let relsData = try? Data(contentsOf: relsURL)
        else {
            return []
        }

        let slideParser = SlideImageReferenceParser()
        let xmlParser = XMLParser(data: slideData)
        xmlParser.delegate = slideParser
        xmlParser.parse()

        let relsParser = SlideRelationshipParser()
        let relParser = XMLParser(data: relsData)
        relParser.delegate = relsParser
        relParser.parse()

        var result: [URL] = []

        for relationshipID in slideParser.relationshipIDs {
            guard let target = relsParser.targetsByID[relationshipID] else {
                continue
            }

            guard isImageTarget(target) else {
                continue
            }

            let mediaURL = slidesFolder
                .appendingPathComponent(target)
                .standardizedFileURL

            result.append(mediaURL)
        }

        return removeDuplicatesPreservingOrder(result)
    }

    private static func makePhotoCandidate(from url: URL) -> PhotoCandidate? {
        guard let image = NSImage(contentsOf: url) else {
            return nil
        }

        return PhotoCandidate(
            url: url,
            width: image.size.width,
            height: image.size.height,
            captureDate: nil
        )
    }

    private static func slideNumber(_ url: URL) -> Int {
        let name = url.deletingPathExtension().lastPathComponent
        let digits = name.filter { $0.isNumber }
        return Int(digits) ?? 0
    }

    private static func isImageTarget(_ target: String) -> Bool {
        let lower = target.lowercased()
        return lower.hasSuffix(".jpg")
            || lower.hasSuffix(".jpeg")
            || lower.hasSuffix(".png")
            || lower.hasSuffix(".tif")
            || lower.hasSuffix(".tiff")
    }

    private static func removeDuplicatesPreservingOrder(_ urls: [URL]) -> [URL] {
        var seen = Set<String>()
        var result: [URL] = []

        for url in urls {
            let key = url.path
            if !seen.contains(key) {
                seen.insert(key)
                result.append(url)
            }
        }

        return result
    }
}

final class SlideImageReferenceParser: NSObject, XMLParserDelegate {

    var relationshipIDs: [String] = []

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        for (key, value) in attributeDict {
            if key == "r:embed" || key == "embed" || key.hasSuffix(":embed") {
                relationshipIDs.append(value)
            }
        }
    }
}

final class SlideRelationshipParser: NSObject, XMLParserDelegate {

    var targetsByID: [String: String] = [:]

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        guard elementName == "Relationship" else {
            return
        }

        guard
            let id = attributeDict["Id"],
            let target = attributeDict["Target"]
        else {
            return
        }

        targetsByID[id] = target
    }
}
