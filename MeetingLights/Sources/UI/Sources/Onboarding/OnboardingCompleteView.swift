import SwiftUI

struct OnboardingCompleteView: View {
    var launchAtLogin: Binding<Bool>
    var onContinue: () -> Void
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 40) {
                SFSymbol
                    .checkmarkCircle
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                    .frame(height: 160)

                VStack(spacing: 4) {
                    Text("Setup complete")
                        .font(.largeTitle)
                        .bold()
                    Text("Go ahead, open FaceTime and try Lumi out!")
                }
                
                Button(
                    "Open FaceTime",
                    action: { NSWorkspace.shared.open(URL(string: "facetime:")!) }
                )
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Toggle("Launch Lumi at login", isOn: self.launchAtLogin)
                
                Button(
                    action: self.onContinue,
                    label: {
                        Text("Finish")
                            .frame(minWidth: 60)
                    }
                )
                .keyboardShortcut(.return)
                .controlSize(.large)
            }
        }
    }
}

// MARK: Preview

#if DEBUG
struct OnboardingCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingCompleteView(
                launchAtLogin: .constant(false),
                onContinue: {}
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            
            OnboardingCompleteView(
                launchAtLogin: .constant(true),
                onContinue: {}
            )
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
