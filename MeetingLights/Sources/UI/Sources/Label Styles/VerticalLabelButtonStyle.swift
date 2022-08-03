import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 4) {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: LabelStyle

extension LabelStyle where Self == VerticalLabelStyle {
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
