import AppKit

struct AppState: Equatable {
    var connectedLight: NanoleafLight? = nil
    
    // MARK: Onboarding
    var onboarding: OnboardingState = .init()
    
    // MARK: Settings
    var settings: SettingsState = .init()
}
