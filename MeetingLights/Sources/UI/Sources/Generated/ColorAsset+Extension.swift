import SwiftUI

/// This extension allows us to use ImageAsset as a view within SwiftUI.
extension ColorAsset: View {
    var swiftUIColor: SwiftUI.Color {
        SwiftUI.Color(nsColor: self.color)
    }

    var body: SwiftUI.Color {
        self.swiftUIColor
    }
}
