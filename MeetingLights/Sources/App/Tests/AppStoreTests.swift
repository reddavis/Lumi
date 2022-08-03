@testable import Lumi
import Asynchrone
import Nanoleaf
import XCTest

final class AppStoreTests: XCTestCase {
    func testAppLaunching() async {
        // Setup
        let launchAtLogin = true
        let light = NanoleafLight.fixture()
        let store = await AppStore.test(
            environment: .mock(
                lightProvider: .mock(
                    current: { light }
                ),
                settingsProvider: .mock(
                    launchAtLogin: { launchAtLogin }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .appLifeCycle(.didFinishLaunching),
            matches: [
                .init(),
                .init(
                    connectedLight: light,
                    onboarding: .init(launchAtLogin: launchAtLogin),
                    settings: .init(launchAtLogin: launchAtLogin)
                )
            ]
        )
    }
    
    func testCameraStateDidChangeToEnabled() async {
        // Setup
        var enableIsCalled = false
        let initialState = AppState(connectedLight: .fixture())
        
        let store = await AppStore.test(
            state: initialState,
            environment: .mock(
                lightProvider: .mock(
                    enable: { _, _ in enableIsCalled = true }
                ),
                tokenProvider: .mock(
                    token: { _ in "token" }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .cameraStateDidChange(isOn: true),
            matches: [initialState]
        )
        
        await XCTAssertEventuallyTrue(enableIsCalled)
    }
    
    func testCameraStateDidChangeToDisabled() async {
        // Setup
        var disableIsCalled = false
        let initialState = AppState(connectedLight: .fixture())
        
        let store = await AppStore.test(
            state: initialState,
            environment: .mock(
                lightProvider: .mock(
                    disable: { _, _ in disableIsCalled = true }
                ),
                tokenProvider: .mock(
                    token: { _ in "token" }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .cameraStateDidChange(isOn: false),
            matches: [initialState]
        )
        
        await XCTAssertEventuallyTrue(disableIsCalled)
    }
    
    func testOnboardingDidResolveDevice() async {
        // Setup
        let light = NanoleafLight.fixture()
        let store = await AppStore.test()

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .onboarding(.didResolveDevice(light: light)),
            matches: [
                .init(),
                .init(connectedLight: light, onboarding: .init(stage: .complete))
            ]
        )
    }
}
