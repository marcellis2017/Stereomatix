import SwiftUI

enum Screen {
    case home
    case identify
    case reformat
    case extract
}

struct ContentView: View {

    @State private var currentScreen: Screen = .home

    var body: some View {
        switch currentScreen {
        case .home:
            HomeView(currentScreen: $currentScreen)
        case .identify:
            PlaceholderView(title: "Identify Stereo Pairs", currentScreen: $currentScreen)
        case .reformat:
            PlaceholderView(title: "Reformat PowerPoints", currentScreen: $currentScreen)
        case .extract:
            PlaceholderView(title: "Extract Images", currentScreen: $currentScreen)
        }
    }
}

struct HomeView: View {

    @Binding var currentScreen: Screen

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

                ZStack {
                    Image("MHLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500)
                        .opacity(0.85)

                    VStack(spacing: 6) {
                        Text("STEREOMATIX")
                            .font(.system(size: 56, weight: .black))
                            .foregroundColor(.white)

                        Text("Stereo Photography Workbench")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 320)

                MenuButton(
                    title: "Identify Stereo Pairs",
                    subtitle: "Find left/right pairs and build PowerPoint pages"
                ) {
                    currentScreen = .identify
                }

                MenuButton(
                    title: "Reformat PowerPoints",
                    subtitle: "Apply your preferred stereo template"
                ) {
                    currentScreen = .reformat
                }

                MenuButton(
                    title: "Extract Images",
                    subtitle: "Export stereo images from PowerPoint decks"
                ) {
                    currentScreen = .extract
                }

                Spacer()

                Text("Version 0.1 Alpha")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .padding(40)
        }
    }
}

struct PlaceholderView: View {

    let title: String
    @Binding var currentScreen: Screen

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Button("← Back") {
                    currentScreen = .home
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct MenuButton: View {

    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text(subtitle)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .buttonStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
