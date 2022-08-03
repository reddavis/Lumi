import Asynchrone
import Nanoleaf
import RedUx

enum OnboardingReducer {
    private static let searchForDevices = "searchForDevices"
    
    static let main: Reducer<OnboardingState, OnboardingEvent, OnboardingEnvironment>
    = Reducer { state, event, environment in
        switch event {
        // Searching for device
        case .startSearchingForDevices:
            state.stage = .selectDevice(identifiers: .loading(nil))
            return environment
                .deviceOnboardingProvider
                .startBrowsingDevices()
                .map(OnboardingEvent.didFindDevices)
                .eraseToEffect(id: Self.searchForDevices)
        case .didFindDevices(let devices):
            state.stage = .selectDevice(identifiers: .complete(devices))
            return .cancel(Self.searchForDevices)
            
        // Stage
        case .setStage(let stage):
            state.stage = stage
            return .none
        
        // Resolving device
        case .resolveDevice(let identifier):
            state.stage = .connectToDevice(identifier, isConnecting: true)
            
            return Effect {
                do {
                    let address = try await environment.deviceOnboardingProvider.resolveDevice(identifier)
                    let token = try await environment.deviceOnboardingProvider.fetchToken(address)
                    let light = NanoleafLight(deviceIdentifier: identifier, address: address)
                    try environment.tokenProvider.setToken(token, light)
                    await environment.lightProvider.save(light)
                    
                    return .didResolveDevice(light: light)
                } catch {
                    return .failedResolvingDevice(identifier, error: .build(error))
                }
            }
        case .didResolveDevice:
            state.stage = .complete
            return .none
        case .failedResolvingDevice(let identifier, let error):
            state.stage = .connectToDevice(identifier, isConnecting: false)
            return .none
            
        // Launch at login
        case .setLaunchAtLogin(let isEnabled):
            environment.settingsProvider.setLaunchAtLogin(isEnabled)
            state.launchAtLogin = isEnabled
            return .none
        }
    }
}
