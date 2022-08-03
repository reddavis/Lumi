import Foundation
import LaunchAtLogin

struct SettingsProvider {
    let launchAtLogin: () -> Bool
    let setLaunchAtLogin: (Bool) -> Void
}

// MARK: Main

extension SettingsProvider {
    static func main() -> Self {
        .init(
            launchAtLogin: {
                LaunchAtLogin.isEnabled
            },
            setLaunchAtLogin: { launchAtLogin in
                LaunchAtLogin.isEnabled = launchAtLogin
            }
        )
    }
}

// MARK: Mock

extension SettingsProvider {
    static func mock(
        launchAtLogin: @escaping () -> Bool = { true },
        setLaunchAtLogin: @escaping (Bool) -> Void = { _ in }
    ) -> Self {
        .init(
            launchAtLogin: launchAtLogin,
            setLaunchAtLogin: setLaunchAtLogin
        )
    }
}
