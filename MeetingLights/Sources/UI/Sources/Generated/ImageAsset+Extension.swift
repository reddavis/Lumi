import SwiftUI

/// This extension allows us to use ImageAsset as a view within SwiftUI.
extension ImageAsset: View {
    var swiftUIImage: SwiftUI.Image {
        SwiftUI.Image(nsImage: self.image)
    }

    var body: SwiftUI.Image {
        self.swiftUIImage
    }

    func resizable() -> some View {
        self.body.resizable()
    }
}
