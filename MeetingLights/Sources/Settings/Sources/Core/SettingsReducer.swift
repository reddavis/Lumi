import Asynchrone
import RedUx

enum SettingsReducer {
    static let main: Reducer<SettingsState, SettingsEvent, SettingsEnvironment>
    = Reducer { state, event, environment in
        switch event {
        case .setLaunchAtLogin(let isEnabled):
            environment.settingsProvider.setLaunchAtLogin(isEnabled)
            state.launchAtLogin = isEnabled
            return .none
        }
    }
}
