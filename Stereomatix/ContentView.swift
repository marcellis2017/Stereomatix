import SwiftUI

enum AppScreen {
    case welcome
    case acquire
}

struct ContentView: View {

    @State private var currentScreen: AppScreen = .welcome

    var body: some View {
        switch currentScreen {
        case .welcome:
            WelcomeView(currentScreen: $currentScreen)

        case .acquire:
            Text("Acquire screen coming next")
                .font(.largeTitle.bold())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
