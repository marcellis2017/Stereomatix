import Foundation
import AppKit

struct FolderScanner {

    static func acquireBatch(
        folderURL: URL,
        onlySquarePhotos: Bool,
        maximumTimeDifference: Double
    ) -> Batch {

        let supportedExtensions = ["jpg", "jpeg", "png", "heic", "tif", "tiff"]

        guard let files = try? FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: [.creationDateKey, .contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else {
            return Batch(
                sourceName: folderURL.lastPathComponent,
                totalImagesScanned: 0,
                groups: []
            )
        }

        let imageFiles = files.filter {
            supportedExtensions.contains($0.pathExtension.lowercased())
        }

        let allPhotos: [PhotoCandidate] = imageFiles.compactMap { url in
            guard let image = NSImage(contentsOf: url) else {
                return nil
            }

            let values = try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
            let date = values?.creationDate ?? values?.contentModificationDate

            return PhotoCandidate(
                url: url,
                width: image.size.width,
                height: image.size.height,
                captureDate: date
            )
        }

        let candidates = onlySquarePhotos
            ? allPhotos.filter { $0.isSquare }
            : allPhotos

        let pairs = StereoPairFinder.findPairs(
            in: candidates,
            maximumTimeDifference: maximumTimeDifference
        )

        let group = AcquisitionGroup(
            title: folderURL.lastPathComponent,
            stereoPairs: pairs
        )

        return Batch(
            sourceName: folderURL.lastPathComponent,
            totalImagesScanned: imageFiles.count,
            groups: [group]
        )
    }
}
