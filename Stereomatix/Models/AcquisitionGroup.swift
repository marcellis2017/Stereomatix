//
//  AcquisitionGroup.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation

struct AcquisitionGroup: Identifiable {

    let id = UUID()

    let title: String

    var stereoPairs: [StereoPair]
}
