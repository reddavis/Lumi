import Foundation
import Nanoleaf
import Papyrus

struct NanoleafLight: Papyrus, Hashable {
    var id: String {
        let invalidCharacters = CharacterSet(
            charactersIn: "\\/:*?\"<>|"
        )
        .union(.newlines)
        .union(.illegalCharacters)
        .union(.controlCharacters)
        
        return self.url
            .absoluteString
            .components(separatedBy: invalidCharacters)
            .joined(separator: "")
    }
    
    var name: String
    var type: String
    var domain: String
    var hostName: String
    var port: Int
    
    var url: URL {
        URL(string: "http://\(self.hostName):\(self.port)")!
    }
    
    // MARK: Initialization
    
    init(
        name: String,
        type: String,
        domain: String,
        hostName: String,
        port: Int
    ) {
        self.name = name
        self.type = type
        self.domain = domain
        self.hostName = hostName
        self.port = port
    }
    
    init(
        deviceIdentifier: DeviceIdentifier,
        address: DeviceAddress
    ) {
        self.init(
            name: deviceIdentifier.name,
            type: deviceIdentifier.type,
            domain: deviceIdentifier.domain,
            hostName: address.hostName,
            port: address.port
        )
    }
}

// MARK: Fixture

extension NanoleafLight: Fixture {
    public static func fixture(_ configure: ((inout Self) -> Void)? = nil) -> Self {
        var fixture = NanoleafLight(
            name: "Shapes 999",
            type: "_nanoleafapi._tcp",
            domain: "local.",
            hostName: "something.local.",
            port: 1234
        )
        configure?(&fixture)
        return fixture
    }
}
