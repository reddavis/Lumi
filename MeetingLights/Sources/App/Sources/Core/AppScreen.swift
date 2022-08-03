import RedUx
import SwiftUI

struct AppScreen: View, RedUxable {
    typealias LocalState = AppState
    typealias LocalEvent = AppEvent
    typealias LocalEnvironment = AppEnvironment

    let store: LocalStore
    @StateObject var viewModel: LocalViewModel
    
    // MARK: Initialization
    
    init(store: LocalStore, viewModel: LocalViewModel) {
        self.store = store
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        OnboardingScreen.make(
            store: self.store.scope(
                state: \.onboarding,
                event: AppEvent.onboarding,
                environment: OnboardingEnvironment.fromAppEnvironment
            )
        )
    }
}

// MARK: Preview

#if DEBUG
extension AppScreen {
    static func fixture(_ state: AppState = .init()) -> Self {
        AppScreen.mock(
            state: state,
            environment: .mock()
        )
    }
    
    static var idle: some View {
        self.fixture()
    }
}

struct AppScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppScreen.idle
            .previewDisplayName("Idle")
        AppScreen.idle
            .preferredColorScheme(.dark)
            .previewDisplayName("Idle (dark)")
    }
}
#endif
