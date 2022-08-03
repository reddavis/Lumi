import Nanoleaf
import RedUx
import SwiftUI
import Toolbox

struct OnboardingScreen: View, RedUxable {
    typealias LocalState = OnboardingState
    typealias LocalEvent = OnboardingEvent
    typealias LocalEnvironment = OnboardingEnvironment

    let store: LocalStore
    @StateObject var viewModel: LocalViewModel
    
    // MARK: Initialization
    
    init(store: LocalStore, viewModel: LocalViewModel) {
        self.store = store
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        HStack(alignment: .bottom) {
            switch self.viewModel.stage {
            case .intro:
                OnboardingIntroView(
                    onContinue: {
                        self.viewModel.send(.setStage(.selectDevice(identifiers: .idle)))
                    }
                )
            case .selectDevice(let devices):
                OnboardingSelectDeviceView(
                    devices: devices,
                    onBack: { self.viewModel.send(.setStage(.intro)) },
                    onContinue: {
                        self.viewModel.send(.setStage(.connectToDevice($0, isConnecting: false)))
                    }
                )
                .task {
                    self.viewModel.send(.startSearchingForDevices)
                }
            case .connectToDevice(let device, let isConnecting):
                OnboardingConnectDeviceView(
                    device: device,
                    isConnecting: isConnecting,
                    onBack: {
                        self.viewModel.send(.setStage(.selectDevice(identifiers: .idle)))
                    },
                    onContinue: { self.viewModel.send(.resolveDevice(device)) }
                )
            case .complete:
                OnboardingCompleteView(
                    launchAtLogin: self.viewModel.binding(
                        value: \.launchAtLogin,
                        event: OnboardingEvent.setLaunchAtLogin
                    ),
                    onContinue: { NSApplication.shared.keyWindow?.close() }
                )
            }
        }
        .padding(32)
        .frame(
            width: 800,
            height: 600
        )
        .navigationTitle("Lumi")
    }
}

// MARK: Preview

#if DEBUG
extension OnboardingScreen {
    static func fixture(_ state: OnboardingState = .init()) -> Self {
        OnboardingScreen.mock(
            state: state,
            environment: .mock()
        )
    }
    
    static var intro: some View {
        self.fixture()
    }
    
    static var selectDevice: some View {
        self.fixture(
            .init(
                stage: .selectDevice(
                    identifiers: .complete([.fixture(), .fixture()])
                )
            )
        )
    }
    
    static var connectToDevice: some View {
        self.fixture(
            .init(
                stage: .connectToDevice(.fixture(), isConnecting: false)
            )
        )
    }
    
    static var connectingToDevice: some View {
        self.fixture(
            .init(
                stage: .connectToDevice(.fixture(), isConnecting: true)
            )
        )
    }
    
    static var complete: some View {
        self.fixture(.init(stage: .complete))
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen.intro
            .previewDisplayName("Intro")
        OnboardingScreen.intro
            .preferredColorScheme(.dark)
            .previewDisplayName("Intro (dark)")
        
        OnboardingScreen.selectDevice
            .previewDisplayName("Select device")
        OnboardingScreen.selectDevice
            .preferredColorScheme(.dark)
            .previewDisplayName("Select device (dark)")
        
        OnboardingScreen.connectToDevice
            .previewDisplayName("Connect to device")
        OnboardingScreen.connectToDevice
            .preferredColorScheme(.dark)
            .previewDisplayName("Connect to device (dark)")
        
        OnboardingScreen.connectingToDevice
            .previewDisplayName("Connecting to device")
        OnboardingScreen.connectingToDevice
            .preferredColorScheme(.dark)
            .previewDisplayName("Connecting to device (dark)")
        
        OnboardingScreen.complete
            .previewDisplayName("Complete")
        OnboardingScreen.complete
            .preferredColorScheme(.dark)
            .previewDisplayName("Complete (dark)")
    }
}
#endif
