enum SettingsEvent {
    case setLaunchAtLogin(Bool)
}

// MARK: Builder

extension SettingsEvent {
    static func fromAppEvent(_ event: AppEvent) -> Self? {
        guard case let AppEvent.settings(localEvent) = event else { return nil }
        return localEvent
    }
}
