//
//  Batch.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation

struct Batch {
    let sourceName: String
    let totalImagesScanned: Int
    var groups: [AcquisitionGroup]

    var stereoPairsFound: Int {
        groups.reduce(0) { $0 + $1.stereoPairs.count }
    }

    var includedPairsCount: Int {
        groups.reduce(0) { total, group in
            total + group.stereoPairs.filter { $0.included }.count
        }
    }
}
