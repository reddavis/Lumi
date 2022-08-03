import Nanoleaf
import RedUx
import SwiftUI

struct OnboardingSelectDeviceView: View {
    var devices: ValueStatus<[DeviceIdentifier], ApplicationError>
    var onBack: () -> Void
    var onContinue: (_ identifier: DeviceIdentifier) -> Void
    
    // Private
    @State private var selectedDevice: DeviceIdentifier? = nil
    @State private var didAppear: Bool = false
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 4) {
                Text("Select Your Nanoleaf Device")
                    .font(.largeTitle)
                    .bold()
                Text("To connect your Nanoleaf devices to Lumi, select a device and click Continue.")
            }
            
            Spacer()
            
            switch self.devices {
            case .idle, .loading:
                self.list(devices: [], isLoading: true)
            case .complete(let devices):
                self.list(devices: devices, isLoading: false)
            case .failed(let error, _):
                self.errorUI(error)
            }
            
            Spacer()
            
            self.buttons()
        }
        .onAppear {
            self.didAppear = true
        }
    }
    
    // MARK: UI
    
    private func list(devices: [DeviceIdentifier], isLoading: Bool) -> some View {
        List(
            devices,
            id: \.self,
            selection: self.$selectedDevice,
            rowContent: { device in
                Text(device.name)
            }
        )
        .padding(4)
        .listStyle(.plain)
        .background(Color(nsColor: NSColor.unemphasizedSelectedContentBackgroundColor))
        .cornerRadius(4)
        .frame(width: 400, height: 100)
        .isLoading(isLoading)
    }
    
    private func errorUI(_ error: ApplicationError) -> some View {
        Text(error.localizedDescription)
            .foregroundColor(.red)
    }
    
    private func buttons() -> some View {
        HStack {
            Button(
                action: self.onBack,
                label: {
                    Text("Back")
                        .frame(minWidth: 60)
                }
            )
            .controlSize(.large)
            
            Button(
                action: {
                    guard let device = self.selectedDevice else { return }
                    self.onContinue(device)
                },
                label: {
                    Text("Continue")
                        .frame(minWidth: 60)
                }
            )
            .disabled(self.selectedDevice == nil)
            .keyboardShortcut(.return)
            .controlSize(.large)
        }
    }
}

// MARK: Preview

#if DEBUG
struct OnboardingSelectDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingSelectDeviceView(
                devices: .complete([.fixture(), .fixture()]),
                onBack: {},
                onContinue: { _ in }
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            
            OnboardingSelectDeviceView(
                devices: .complete([.fixture(), .fixture()]),
                onBack: {},
                onContinue: { _ in }
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        }
    }
}
#endif
