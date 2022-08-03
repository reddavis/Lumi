import Nanoleaf
import Papyrus
import Valet

struct AppEnvironment {
    static func main(
        apiClient: NanoleafClient = .main(),
        store: PapyrusStore = .main,
        valet: Valet = .main
    ) -> Self {
        .init(
            lightProvider: .main(store: store, apiClient: apiClient),
            tokenProvider: .main(valet: valet),
            deviceOnboardingProvider: .main(apiClient: apiClient, browser: .init()),
            settingsProvider: .main(),
            cameraMonitor: .init(cameras: Camera.all)
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
            settingsProvider: settingsProvider,
            cameraMonitor: .init(cameras: [])
        )
    }
    #endif
    
    // Internal
    let lightProvider: NanoleafLightProvider
    let tokenProvider: TokenProvider
    let deviceOnboardingProvider: DeviceOnboardingProvider
    let settingsProvider: SettingsProvider
    let cameraMonitor: CameraMonitor
}
