import AppKit
import Asynchrone
import RedUx

enum AppReducer {
    private static let cameraObserverID = UUID().uuidString
    
    static let main: Reducer<AppState, AppEvent, AppEnvironment> = Reducer { state, event, environment in
        switch event {
        // MARK: App lifecycle
        case .appLifeCycle(.didFinishLaunching):
            return Effect(.initializeState)
                .chain(with: Effect(.startCameraMonitoring))
                .eraseToEffect()
            
        // MARK: State initialization
        case .initializeState:
            return Effect {
                let connectedLight = try? await environment.lightProvider.current()
                let launchAtLogin = environment.settingsProvider.launchAtLogin()
                return .didInitializeState(
                    .init(
                        connectedLight: connectedLight,
                        onboarding: .init(launchAtLogin: launchAtLogin),
                        settings: .init(launchAtLogin: launchAtLogin)
                    )
                )
            }
        case .didInitializeState(let loadedState):
            state = loadedState
            return .none
        
        // MARK: Camera
        case .startCameraMonitoring:
            environment.cameraMonitor.start()
            return environment
                .cameraMonitor
                .output
                .debounce(for: 0.3)
                .map(AppEvent.cameraStateDidChange(isOn:))
                .eraseToEffect(id: cameraObserverID)
        case .cameraStateDidChange(let isOn):
            guard let light = state.connectedLight else { return .none }
            return .fireAndForget {
                do {
                    let token = try environment.tokenProvider.token(light)
                    
                    if isOn {
                        try await environment.lightProvider.enable(light, token)
                    } else {
                        try await environment.lightProvider.disable(light, token)
                    }
                } catch {}
            }
        
        // MARK: Device
        case .removeCurrentDevice:
            return Effect {
                do {
                    let device = try await environment.lightProvider.current()
                    await environment.lightProvider.delete(device)
                    try environment.tokenProvider.removeToken(device)
                } catch { }
                
                return .didRemoveCurrentDevice
            }
        case .didRemoveCurrentDevice:
            state.onboarding = .init(launchAtLogin: environment.settingsProvider.launchAtLogin())
            state.connectedLight = nil
            return Effect(.presentWindow(.setup))
            
        // Window
        case .presentWindow(let identifier):
            NSWorkspace.shared.open(identifier.url)
            return .none
            
        // Onboarding
        case .onboarding(.didResolveDevice(let light)):
            state.connectedLight = light
            return .none
        
        default:
            return .none
        }
    }
    <>
    OnboardingReducer.main.pull(
        state: \.onboarding,
        appState: { app, onboarding in
            app.onboarding = onboarding
            app.settings.launchAtLogin = onboarding.launchAtLogin
        },
        event: OnboardingEvent.fromAppEvent,
        appEvent: AppEvent.onboarding,
        environment: OnboardingEnvironment.fromAppEnvironment
    )
    <>
    SettingsReducer.main.pull(
        state: \.settings,
        event: SettingsEvent.fromAppEvent,
        appEvent: AppEvent.settings,
        environment: SettingsEnvironment.fromAppEnvironment
    )
}
