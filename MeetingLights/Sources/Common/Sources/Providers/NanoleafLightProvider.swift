import Asynchrone
import Foundation
import Nanoleaf
import Papyrus

struct NanoleafLightProvider {
    let current: () async throws -> NanoleafLight
    let save: (NanoleafLight) async -> Void
    let delete: (NanoleafLight) async -> Void
    let enable: (NanoleafLight, _ token: String) async throws -> Void
    let disable: (NanoleafLight, _ token: String) async throws -> Void
}

// MARK: Main

extension NanoleafLightProvider {
    static private var configurations: [String: Device] = [:]
    
    static func main(
        store: PapyrusStore,
        apiClient: NanoleafClient
    ) -> Self {
        .init(
            current: {
                guard
                    let light = await store
                        .objects(type: NanoleafLight.self)
                        .execute()
                        .first else {
                    throw NanoleafLightProviderError.notFound
                }
                
                return light
            },
            save: { light in
                await store.save(light)
            },
            delete: { light in
                await store.delete(light)
            },
            enable: { light, token in
                // Save current configuration
                let fetchPanelCollectionRequest = FetchDeviceRequest(
                    url: light.url,
                    token: token
                )
                let panelCollection = try await apiClient.execute(request: fetchPanelCollectionRequest)
                Self.configurations[light.id] = panelCollection
                
                // Update lights for video call
                let updateStateRequest = try UpdateStateRequest(
                    url: light.url,
                    token: token,
                    isOn: true,
                    brightness: .init(value: 50),
                    hue: .init(value: 0),
                    saturation: .init(value: 0),
                    colorTemperature: .init(value: 4000)
                )
                try await apiClient.execute(request: updateStateRequest)
            },
            disable: { light, token in
                guard let configuration = Self.configurations[light.id] else {
                    return
                }
                
                switch configuration.state.colorMode {
                case .colorTemperature:
                    let request = try UpdateStateRequest(
                        url: light.url,
                        token: token,
                        isOn: configuration.state.on.value,
                        brightness: .init(value: configuration.state.brightness.value),
                        colorTemperature: .init(value: configuration.state.colorTemperature.value)
                    )
                    try await apiClient.execute(request: request)
                case .hueSaturation:
                    let request = try UpdateStateRequest(
                        url: light.url,
                        token: token,
                        isOn: configuration.state.on.value,
                        brightness: .init(value: configuration.state.brightness.value),
                        hue: .init(value: configuration.state.hue.value),
                        saturation: .init(value: configuration.state.saturation.value)
                    )
                    try await apiClient.execute(request: request)
                case .effect where configuration.state.on.value:
                    let request = try UpdateSelectedEffectRequest(
                        url: light.url,
                        token: token,
                        effect: configuration.effectList.current
                    )
                    try await apiClient.execute(request: request)
                default:
                    let request = try UpdateStateRequest(
                        url: light.url,
                        token: token,
                        isOn: false
                    )
                    try await apiClient.execute(request: request)
                }
            }
        )
    }
}

// MARK: Error

enum NanoleafLightProviderError: Error {
    case notFound
}

// MARK: Mock

extension NanoleafLightProvider {
    static func mock(
        current: @escaping () async throws -> NanoleafLight = {
            .fixture()
        },
        save: @escaping (NanoleafLight) async -> Void = { _ in },
        delete: @escaping (NanoleafLight) async -> Void = { _ in },
        enable: @escaping (NanoleafLight, _ token: String) async throws -> Void = { _, _ in },
        disable: @escaping (NanoleafLight, _ token: String) async throws -> Void = { _, _ in }
    ) -> Self {
        .init(
            current: current,
            save: save,
            delete: delete,
            enable: enable,
            disable: disable
        )
    }
}
