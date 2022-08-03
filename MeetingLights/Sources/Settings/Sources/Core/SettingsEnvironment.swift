struct SettingsEnvironment {
    static func main() -> Self {
        .init(settingsProvider: .main())
    }

    #if DEBUG || ADHOC
    static func mock() -> Self {
        .init(settingsProvider: .mock())
    }
    #endif
    
    // Internal
    let settingsProvider: SettingsProvider
}

// MARK: Helpers

extension SettingsEnvironment {
    static func fromAppEnvironment(_ environment: AppEnvironment) -> Self {
        .init(settingsProvider: environment.settingsProvider)
    }
}
