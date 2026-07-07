import SwiftUI

enum AppScreen {
    case welcome
    case acquire
    case workspace
}

struct ContentView: View {

    @State private var currentScreen: AppScreen = .welcome
    @State private var workspacePairs: [StereoPair] = []

    var body: some View {
        switch currentScreen {
        case .welcome:
            WelcomeView(currentScreen: $currentScreen)

        case .acquire:
            AcquireView(
                currentScreen: $currentScreen,
                workspacePairs: $workspacePairs
            )

        case .workspace:
            WorkspaceView(
                currentScreen: $currentScreen,
                stereoPairs: $workspacePairs
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
