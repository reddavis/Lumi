@testable import Lumi
import Asynchrone
import Nanoleaf
import XCTest

final class OnboardingStoreTests: XCTestCase {
    func testSearchingForDevice() async {
        // Setup
        let identifier = DeviceIdentifier.fixture()
        let store = await OnboardingStore.test(
            environment: .mock(
                deviceOnboardingProvider: .mock(
                    startBrowsingDevices: {
                        Just([identifier])
                            .eraseToAnyAsyncSequenceable()
                    }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .startSearchingForDevices,
            matches: [
                .init(),
                .init(stage: .selectDevice(identifiers: .loading(nil))),
                .init(
                    stage: .selectDevice(
                        identifiers: .complete([identifier])
                    )
                )
            ]
        )
    }
    
    func testSettingStage() async {
        // Setup
        let store = await OnboardingStore.test()

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .setStage(.complete),
            matches: [
                .init(),
                .init(stage: .complete)
            ]
        )
    }
    
    func testResolvingDevice() async {
        // Setup
        let identifier = DeviceIdentifier.fixture()
        let address = DeviceAddress.fixture()
        let token = "abc"
        var setTokenCalled = false
        let store = await OnboardingStore.test(
            environment: .mock(
                tokenProvider: .mock(
                    setToken: { newToken, _ in
                        setTokenCalled = true
                        XCTAssertEqual(token, newToken)
                    }
                ),
                deviceOnboardingProvider: .mock(
                    resolveDevice: { _ in address },
                    fetchToken: { _ in token }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .resolveDevice(identifier),
            matches: [
                .init(),
                .init(stage: .connectToDevice(identifier, isConnecting: true)),
                .init(stage: .complete)
            ]
        )
        await XCTAssertEventuallyEqual(true, setTokenCalled)
    }
    
    func testResolvingDeviceFail() async {
        // Setup
        let identifier = DeviceIdentifier.fixture()
        let store = await OnboardingStore.test(
            environment: .mock(
                deviceOnboardingProvider: .mock(
                    resolveDevice: { _ in throw "Error" }
                )
            )
        )

        // Test
        await XCTAssertStateChange(
            store: store,
            event: .resolveDevice(identifier),
            matches: [
                .init(),
                .init(stage: .connectToDevice(identifier, isConnecting: true)),
                .init(stage: .connectToDevice(identifier, isConnecting: false))
            ]
        )
    }
}
