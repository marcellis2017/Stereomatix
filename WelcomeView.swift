//
//  WelcomeView.swift
//  Stereomatix
//
//  Created by Marc Ellis on 06/07/2026.
//

import SwiftUI

struct WelcomeView: View {

    @Binding var currentScreen: AppScreen

    let descriptionText =
    "Stereomatix helps you acquire stereo pairs from folders of photographs or existing PowerPoint presentations, review and organise them, then export them to a range of formats including PowerPoint templates, individual stereo images and EDUCA plates."

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, Color(red: 0.10, green: 0.10, blue: 0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image("MHLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360)
                    .opacity(0.9)

                Text("STEREOMATIX")
                    .font(.system(size: 56, weight: .black))
                    .foregroundColor(.white)

                Text("Stereo Photography Workbench")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text(descriptionText)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 620)

                Spacer()

                Button("Acquire Stereo Pairs") {
                    currentScreen = .acquire
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Text("Version 0.1 Alpha")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 20)
            }
            .padding(40)
        }
    }
}
