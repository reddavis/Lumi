import Nanoleaf
import SwiftUI
import Toolbox

struct OnboardingConnectDeviceView: View {
    var device: DeviceIdentifier
    var isConnecting: Bool
    var onBack: () -> Void
    var onContinue: () -> Void
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("Connect to ")
                .font(.largeTitle)
            +
            Text(self.device.name)
                .bold()
                .font(.largeTitle)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 32) {
                Label(
                    title: {
                        Text("Press and hold the power button untill the control panel lights flash.")
                    },
                    icon: {
                        SFSymbol
                            .power
                            .resizable()
                            .tint(.white)
                            .scaledToFit()
                            .frame(height: 36)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.cyan)
                            }
                    }
                )
                .labelStyle(.bullet(spacing: 16))
                
                Label(
                    title: { Text("Click Continue.") },
                    icon: {
                        SFSymbol
                            .arrowForwardCircle
                            .resizable()
                            .tint(.white)
                            .scaledToFit()
                            .frame(height: 36)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.green)
                            }
                    }
                )
                .labelStyle(.bullet(spacing: 16))
            }
            .frame(maxWidth: 300)

            Spacer()
            
            self.buttons()
                .isLoading(self.isConnecting)
        }
    }
    
    // MARK: UI
    
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
                action: self.onContinue,
                label: {
                    Text("Continue")
                        .frame(minWidth: 60)
                }
            )
            .keyboardShortcut(.return)
            .controlSize(.large)
        }
    }
}

// MARK: Preview

#if DEBUG
struct OnboardingConnectDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingConnectDeviceView(
            device: .fixture(),
            isConnecting: false,
            onBack: {},
            onContinue: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
