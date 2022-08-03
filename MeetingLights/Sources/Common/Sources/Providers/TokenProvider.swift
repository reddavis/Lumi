import Foundation
import Valet

struct TokenProvider {
    let token: (NanoleafLight) throws -> String
    let setToken: (_ token: String, _ light: NanoleafLight) throws -> Void
    let removeToken: (NanoleafLight) throws -> Void
}

// MARK: Main

extension TokenProvider {
    static func main(
        valet: Valet
    ) -> Self {
        .init(
            token: { light in
                try valet.string(forKey: light.id)
            },
            setToken: { token, light in
                try valet.setString(token, forKey: light.id)
            },
            removeToken: { light in
                try valet.removeObject(forKey: light.id)
            }
        )
    }
}

// MARK: Mock

extension TokenProvider {
    static func mock(
        token: @escaping (NanoleafLight) throws -> String = { _ in "token" },
        setToken: @escaping (_ token: String, _ light: NanoleafLight) throws -> Void = { _, _ in },
        removeToken: @escaping (NanoleafLight) throws -> Void = { _ in }
    ) -> Self {
        .init(
            token: token,
            setToken: setToken,
            removeToken: removeToken
        )
    }
}
