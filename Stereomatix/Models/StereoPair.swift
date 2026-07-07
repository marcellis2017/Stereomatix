//
//  StereoCandidate.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation

struct StereoPair: Identifiable {

    let id = UUID()

    let leftPhoto: PhotoCandidate
    let rightPhoto: PhotoCandidate

    let timeDifference: TimeInterval

    var included = true
}
