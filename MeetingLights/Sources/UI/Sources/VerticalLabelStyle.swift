import SwiftUI

struct VerticalLabelButtonStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: LabelStyle

extension LabelStyle where Self == VerticalLabelButtonStyle {
    static var vertical: Self {
        .init()
    }
}

// MARK: Preview

#if DEBUG
struct VerticalLabelStyle_Previews: PreviewProvider {
    static var previews: some View {
        Label("Continue", systemImage: SFSymbol.arrowForwardCircle.rawValue)
            .labelStyle(.vertical)
    }
}
#endif
