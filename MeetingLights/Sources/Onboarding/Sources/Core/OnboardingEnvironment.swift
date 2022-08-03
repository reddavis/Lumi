import Nanoleaf
import Papyrus
import Valet

struct OnboardingEnvironment {
    static func main(
        apiClient: NanoleafClient = .main(),
        store: PapyrusStore = .main,
        valet: Valet = .main
    ) -> Self {
        .init(
            lightProvider: .main(store: store, apiClient: apiClient),
            tokenProvider: .main(valet: valet),
            deviceOnboardingProvider: .main(apiClient: apiClient, browser: .init()),
            settingsProvider: .main()
        )
    }

    #if DEBUG
    static func mock(
        lightProvider: NanoleafLightProvider = .mock(),
        tokenProvider: TokenProvider = .mock(),
        deviceOnboardingProvider: DeviceOnboardingProvider = .mock(),
        settingsProvider: SettingsProvider = .mock()
    ) -> Self {
        .init(
            lightProvider: lightProvider,
            tokenProvider: tokenProvider,
            deviceOnboardingProvider: deviceOnboardingProvider,
            settingsProvider: settingsProvider
        )
    }
    #endif
    
    // Internal
    let lightProvider: NanoleafLightProvider
    let tokenProvider: TokenProvider
    let deviceOnboardingProvider: DeviceOnboardingProvider
    let settingsProvider: SettingsProvider
}

// MARK: Helpers

extension OnboardingEnvironment {
    static func fromAppEnvironment(_ environment: AppEnvironment) -> Self {
        .init(
            lightProvider: environment.lightProvider,
            tokenProvider: environment.tokenProvider,
            deviceOnboardingProvider: environment.deviceOnboardingProvider,
            settingsProvider: environment.settingsProvider
        )
    }
}
