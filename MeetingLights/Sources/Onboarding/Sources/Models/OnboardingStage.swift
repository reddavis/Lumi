import Nanoleaf
import RedUx

enum OnboardingStage: Equatable {
    case intro
    case selectDevice(identifiers: ValueStatus<[DeviceIdentifier], ApplicationError> = .idle)
    case connectToDevice(DeviceIdentifier, isConnecting: Bool)
    case complete
}
