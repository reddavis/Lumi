import RedUx
import SwiftUI

struct SettingsScreen: View, RedUxable {
    typealias LocalState = SettingsState
    typealias LocalEvent = SettingsEvent
    typealias LocalEnvironment = SettingsEnvironment

    let store: LocalStore
    @StateObject var viewModel: LocalViewModel
    
    // MARK: Initialization
    
    init(store: LocalStore, viewModel: LocalViewModel) {
        self.store = store
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        List {}
        .navigationTitle("Settings")
    }
}

// MARK: Preview

#if DEBUG || ADHOC
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsScreen.mock(
                state: .init(),
                environment: .mock()
            )
        }
    }
}
#endif
