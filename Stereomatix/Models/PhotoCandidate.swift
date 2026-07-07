//
//  PhotoCandidate.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation

struct PhotoCandidate: Identifiable {
    let id = UUID()
    let url: URL
    let width: CGFloat
    let height: CGFloat
    let captureDate: Date?

    var isSquare: Bool {
        abs(width - height) < 1
    }
}
