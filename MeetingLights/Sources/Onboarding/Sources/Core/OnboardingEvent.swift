import Nanoleaf

enum OnboardingEvent {
    case setStage(OnboardingStage)
    
    case startSearchingForDevices
    case didFindDevices([DeviceIdentifier])
    
    case resolveDevice(DeviceIdentifier)
    case didResolveDevice(light: NanoleafLight)
    case failedResolvingDevice(DeviceIdentifier, error: ApplicationError)
    
    case setLaunchAtLogin(Bool)
}

// MARK: Helpers

extension OnboardingEvent {
    static func fromAppEvent(_ event: AppEvent) -> Self? {
        guard case let AppEvent.onboarding(localEvent) = event else { return nil }
        return localEvent
    }
}
