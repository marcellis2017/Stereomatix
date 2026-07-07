//
//  WorkspaceView.swift
//  Stereomatix
//
//  Created by Marc Ellis on 07/07/2026.
//

import Foundation
import SwiftUI
import AppKit

struct WorkspaceView: View {

    @Binding var currentScreen: AppScreen
    @Binding var stereoPairs: [StereoPair]

    var includedCount: Int {
        stereoPairs.filter { $0.included }.count
    }

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text("Workspace")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    Button("Back") {
                        currentScreen = .acquire
                    }

                    Button("Export") {
                        // NHE: Export comes later.
                    }
                    .buttonStyle(.borderedProminent)

                }

                Text("\(includedCount) stereo pairs selected")
                    .foregroundColor(.gray)

                Divider()

                ScrollView {

                    LazyVStack(spacing: 16) {

                        ForEach($stereoPairs) { $pair in

                            HStack(alignment: .top, spacing: 20) {

                                Toggle("", isOn: $pair.included)
                                    .labelsHidden()

                                thumbnail(for: pair.leftPhoto)

                                thumbnail(for: pair.rightPhoto)

                                VStack(alignment: .leading, spacing: 6) {

                                    Text(pair.leftPhoto.url.lastPathComponent)
                                        .foregroundColor(.white)

                                    Text(pair.rightPhoto.url.lastPathComponent)
                                        .foregroundColor(.white)

                                    Text(String(format: "%.1f s", pair.timeDifference))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding(30)
        }
    }

    @ViewBuilder
    func thumbnail(for photo: PhotoCandidate) -> some View {

        if let image = NSImage(contentsOf: photo.url) {

            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))

        } else {

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 120)
        }
    }
}
