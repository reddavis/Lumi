import Asynchrone
import Foundation
import Nanoleaf

struct DeviceOnboardingProvider {
    let startBrowsingDevices: () -> AnyAsyncSequenceable<[DeviceIdentifier]>
    let resolveDevice: (DeviceIdentifier) async throws -> DeviceAddress
    let fetchToken: (DeviceAddress) async throws -> String
}

// MARK: Main

extension DeviceOnboardingProvider {
    static func main(
        apiClient: NanoleafClient,
        browser: NanoleafDeviceBrowser
    ) -> Self {
        .init(
            startBrowsingDevices: {
                return browser.identifiers
            },
            resolveDevice: { device in
                let resolver = DeviceAddressResolver(identifier: device)
                return try await resolver.resolve()
            },
            fetchToken: { address in
                let request = AuthenticateRequest(url: address.url)
                return try await apiClient.execute(request: request).token
            }
        )
    }
}

// MARK: Mock

extension DeviceOnboardingProvider {
    static func mock(
        startBrowsingDevices: @escaping () -> AnyAsyncSequenceable<[DeviceIdentifier]> = {
            Just([.fixture()])
                .eraseToAnyAsyncSequenceable()
        },
        resolveDevice: @escaping (DeviceIdentifier) throws -> DeviceAddress = { _ in .fixture() },
        fetchToken: @escaping (DeviceAddress) async throws -> String = { _ in "abc" }
    ) -> Self {
        .init(
            startBrowsingDevices: startBrowsingDevices,
            resolveDevice: resolveDevice,
            fetchToken: fetchToken
        )
    }
}
