import SwiftUI

struct BulletPointLabelStyle: LabelStyle {
    var spacing: Double
    
    // MARK: LabelStyle
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: self.spacing) {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: LabelStyle

extension LabelStyle where Self == BulletPointLabelStyle {
    static func bullet(spacing: Double = 8) -> Self {
        .init(spacing: spacing)
    }
}

// MARK: Preview

#if DEBUG
struct BulletPointLabelStyle_Previews: PreviewProvider {
    static var previews: some View {
        Label("Some really long\ntext blah blah blha", systemImage: SFSymbol.arrowForwardCircle.rawValue)
            .labelStyle(.bullet())
    }
}
#endif
