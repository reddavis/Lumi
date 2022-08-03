import SwiftUI

struct OnboardingIntroView: View {
    var onContinue: () -> Void
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 40) {
                Asset
                    .icon
                    .resizable()
                    .frame(width: 200, height: 200)

                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("Welcome to Lumi")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Level up your video calls.")
                            .font(.title2)
                    }
                    
                    Text("To connect your Nanoleaf device to Lumi, click Continue.")
                }
            }
            
            Spacer()
            
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
struct OnboardingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingIntroView(onContinue: {})
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            OnboardingIntroView(onContinue: {})
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
