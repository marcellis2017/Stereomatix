import Foundation

struct StereoPairFinder {

    static func findPairs(
        in photos: [PhotoCandidate],
        maximumTimeDifference: Double
    ) -> [StereoPair] {

        let sorted = photos
            .filter { $0.captureDate != nil }
            .sorted {
                ($0.captureDate ?? .distantPast) <
                ($1.captureDate ?? .distantPast)
            }

        var result: [StereoPair] = []

        var i = 0

        while i < sorted.count - 1 {

            let first = sorted[i]
            let second = sorted[i + 1]

            guard
                let firstDate = first.captureDate,
                let secondDate = second.captureDate
            else {
                i += 1
                continue
            }

            let delta = secondDate.timeIntervalSince(firstDate)

            if delta > 0 && delta <= maximumTimeDifference {

                result.append(
                    StereoPair(
                        leftPhoto: first,
                        rightPhoto: second,
                        timeDifference: delta
                    )
                )

                i += 2

            } else {

                i += 1

            }
        }

        return result
    }
}
