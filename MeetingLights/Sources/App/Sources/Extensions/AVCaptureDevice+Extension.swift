import AVFoundation
import CoreMediaIO

extension AVCaptureDevice {
    var connectionID: CMIOObjectID? {
        self.value(forKey: "_connectionID") as? CMIOObjectID
    }
}
