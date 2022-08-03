import SwiftUI

@main
struct MeetingLightsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Private
    private let store = AppStore.make()

    // MARK: Initialization

    init() {
        self.appDelegate.store = store
    }
    
    // MARK: Body
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: .zero)
                .task {
                    for await _ in self.store.stateSequence {
                        self.appDelegate.reloadMenubar()
                    }
                }
        }
        
        WindowGroup {
            AppScreen.make(store: self.store)
        }
        .handlesExternalEvents(matching: [WindowGroupIdentifier.setup.rawValue])
    }
}

// MARK: App delegate

final class AppDelegate: NSObject, NSApplicationDelegate {
    fileprivate var store: AppStore?
    fileprivate var statusItem: NSStatusItem?

    // MARK: NSApplicationDelegate

    @MainActor
    func applicationDidFinishLaunching(_ notification: Notification) {
        self.store?.send(.appLifeCycle(.didFinishLaunching))
        self.reloadMenubar()
    }
    
    // MARK: Menubar
    
    @MainActor
    fileprivate func reloadMenubar() {
        guard let store = self.store else { return }
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusItem?.button?.image = NSImage(
            systemSymbolName: SFSymbol.hexagon.rawValue,
            accessibilityDescription: nil
        )
        
        let menu = NSMenu()
        self.statusItem?.menu = menu
        
        if let connectedLight = store.state.connectedLight {
            self.addDisconnectItem(to: menu, for: connectedLight)
        } else {
            self.addSetupItem(to: menu)
        }
        
        self.addLaunchAtLoginItem(
            to: menu,
            state: store.state.settings.launchAtLogin ? .on : .off
        )
        
        menu.addItem(.separator())
        self.addQuitItem(to: menu)
    }
    
    private func addLaunchAtLoginItem(to menu: NSMenu, state: NSControl.StateValue) {
        let item = NSMenuItem()
        item.state = state
        item.title = "Launch at login"
        item.target = self
        item.action = #selector(self.launchAtLoginButtonTapped(_:))
        menu.addItem(item)
    }
    
    private func addDisconnectItem(to menu: NSMenu, for light: NanoleafLight) {
        let item = NSMenuItem()
        item.title = "Disconnect from \(light.name)"
        item.target = self
        item.action = #selector(self.disconnectButtonTapped(_:))
        menu.addItem(item)
    }
    
    private func addSetupItem(to menu: NSMenu) {
        let item = NSMenuItem()
        item.title = "Setup..."
        item.target = self
        item.action = #selector(self.setupButtonTapped(_:))
        menu.addItem(item)
    }
    
    private func addAboutItem(to menu: NSMenu) {
        let item = NSMenuItem()
        item.title = "About Lumi"
        item.target = self
        item.action = #selector(self.aboutButtonTapped(_:))
        menu.addItem(item)
    }
    
    private func addQuitItem(to menu: NSMenu) {
        let item = NSMenuItem()
        item.title = "Quit"
        item.target = self
        item.action = #selector(self.quitButtonTapped(_:))
        menu.addItem(item)
    }
    
    // MARK: Actions
    
    @objc private func aboutButtonTapped(_ sender: Any) {
        // TODO
    }
    
    @MainActor
    @objc private func launchAtLoginButtonTapped(_ sender: Any) {
        guard let store = store else {
            return
        }
        
        store.send(
            .settings(.setLaunchAtLogin(!store.state.settings.launchAtLogin))
        )
    }
    
    @MainActor
    @objc private func setupButtonTapped(_ sender: Any) {
        self.store?.send(.presentWindow(.setup))
    }
    
    @MainActor
    @objc private func disconnectButtonTapped(_ sender: Any) {
        self.store?.send(.removeCurrentDevice)
    }
    
    @objc private func quitButtonTapped(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }
}
