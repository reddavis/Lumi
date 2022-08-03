import AVFoundation
import CoreMediaIO
import Foundation

struct Camera: CustomStringConvertible {
    let connectionID: CMIOObjectID
    
    var description: String {
        "\(self.device.manufacturer)/\(self.device.localizedName)"
    }
    
    var isOn: Bool {
        var propertyAddress = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeWildcard),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementWildcard)
        )
        var dataSize = UInt32(0)
        var dataUsed = UInt32(0)
        
        guard
            CMIOObjectGetPropertyDataSize(self.connectionID, &propertyAddress, 0, nil, &dataSize) == OSStatus(kCMIOHardwareNoError),
            let data = malloc(Int(dataSize)) else {
            return false
        }
        
        CMIOObjectGetPropertyData(self.connectionID, &propertyAddress, 0, nil, dataSize, &dataUsed, data)
        return data.assumingMemoryBound(to: UInt8.self).pointee > 0
    }
    
    // Private
    private let device: AVCaptureDevice
    
    // MARK: Initialization
    
    init(device: AVCaptureDevice) throws {
        guard let connectionID = device.connectionID else { throw CameraInitializationError.connectionIDMissing }
        self.device = device
        self.connectionID = connectionID
    }
}

// MARK: Helpers

extension Camera {
    static var all: [Camera] {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .externalUnknown, .builtInMicrophone],
            mediaType: .video,
            position: .unspecified
        )
        .devices
        .compactMap { try? Camera(device: $0) }
    }
}

// MARK: Initialization error

enum CameraInitializationError: Error {
    case connectionIDMissing
}
