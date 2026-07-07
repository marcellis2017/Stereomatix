//
//  AcquisitionGrouper.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation


struct AcquisitionGrouper {

    static func group(
        stereoPairs: [StereoPair],
        sourceName: String
    ) -> [AcquisitionGroup] {

        return [
            AcquisitionGroup(
                title: sourceName,
                stereoPairs: stereoPairs
            )
        ]
    }
}
