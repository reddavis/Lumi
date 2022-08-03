import SwiftUI

public enum SFSymbol: String {
    case arrowBackwardCircle = "arrow.backward.circle"
    case arrowDownCircleFill = "arrow.down.circle.fill"
    case arrowForwardCircle = "arrow.forward.circle"
    case arrowUpCircleFill = "arrow.up.circle.fill"
    case arrowUpRight = "arrow.up.right"

    case bell = "bell"
    case bellBadge = "bell.badge"
    case bookmark = "bookmark"

    case cameraFill = "camera.fill"
    case checkmarkCircle = "checkmark.circle"
    case chevronLeft = "chevron.left"
    case circleHexagongridFill = "circle.hexagongrid.fill"

    case dollarSignSquare = "dollarsign.square"

    case equalCircleFill = "equal.circle.fill"

    case heart = "heart"
    case heartFill = "heart.fill"
    case heartTextSquare = "heart.text.square"
    case heartTextSquareFill = "heart.text.square.fill"
    case house
    case houseFill = "house.fill"

    case faceID = "faceid"

    case gearShape = "gearshape"
    
    case hexagon

    case linkCircleFill = "link.circle.fill"

    case message
    case magnifyingglass = "magnifyingglass"

    case paperplaneFill = "paperplane.fill"
    case person
    case person2 = "person.2"
    case personCropCircle = "person.crop.circle"
    case photoFillOnRectangleFill = "photo.fill.on.rectangle.fill"
    case pills = "pills"
    case plus = "plus"
    case plusCircle = "plus.circle"
    case power
    case powerCircle = "power.circle"

    case newspaper = "newspaper"

    case rightChevron = "chevron.right"

    case squareAndArrowUp = "square.and.arrow.up"
    case squareGrid2x2 = "square.grid.2x2"
    case squareGrid2x2Fill = "square.grid.2x2.fill"

    case testtube2 = "testtube.2"
    case textBubble = "text.bubble"
    case textBubbleFill = "text.bubble.fill"

    case wifi
    
    case xmark
    case xmarkCircleFill = "xmark.circle.fill"
}

// MARK: View

extension SFSymbol: View {
    public var body: Image {
        Image(systemName: rawValue)
    }

    public func resizable() -> some View {
        body.resizable()
    }
}
