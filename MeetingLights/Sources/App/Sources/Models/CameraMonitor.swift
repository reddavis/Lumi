import Asynchrone
import CoreMediaIO
import Foundation

final class CameraMonitor {
    let output: AnyAsyncSequenceable<Bool>

    // Private
    private let _output: PassthroughAsyncSequence<Bool> = .init()
    private let cameras: [Camera]
    private var listeners: [CMIOObjectPropertyListenerBlock] = []
    private var propertyAddresses: [CMIOObjectPropertyAddress] = []
    
    // MARK: Initialization
    
    init(cameras: [Camera]) {
        self.cameras = cameras
        self.output = self._output.eraseToAnyAsyncSequenceable()
    }
    
    // MARK: API
    
    func start() {
        self.listeners.removeAll()
        self.propertyAddresses.removeAll()
        
        for camera in self.cameras {
            let listener: CMIOObjectPropertyListenerBlock = { [weak self] _, _ in
                self?.cameraDidChange()
            }
            
            var propertyAddress = CMIOObjectPropertyAddress(
                mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
                mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeWildcard),
                mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementWildcard)
            )
            
            CMIOObjectAddPropertyListenerBlock(
                camera.connectionID,
                &propertyAddress,
                DispatchQueue.global(qos: .userInitiated),
                listener
            )
            
            self.listeners.append(listener)
            self.propertyAddresses.append(propertyAddress)
        }
    }
    
    private func stop() {
        for (index, listener) in self.listeners.enumerated() {
            CMIOObjectRemovePropertyListenerBlock(
                self.cameras[index].connectionID,
                &self.propertyAddresses[index],
                DispatchQueue.global(qos: .userInitiated),
                listener
            )
        }
        
        self.listeners.removeAll()
        self.propertyAddresses.removeAll()
    }
    
    // MARK: Listener
    
    private func cameraDidChange() {
        let isOn = self.cameras
            .map(\.isOn)
            .contains(true)
        self._output.yield(isOn)
    }
}
