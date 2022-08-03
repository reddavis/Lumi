import AppKit

enum AppEvent {
    case initializeState
    case didInitializeState(AppState)
    
    case startCameraMonitoring
    case cameraStateDidChange(isOn: Bool)
    
    case removeCurrentDevice
    case didRemoveCurrentDevice
    
    case presentWindow(WindowGroupIdentifier)
    
    case appLifeCycle(AppLifeCycleEvent)
    case onboarding(OnboardingEvent)
    case settings(SettingsEvent)
}
