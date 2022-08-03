import Foundation
import Valet

extension Valet {
    static var main: Valet {
        .valet(
            with: .init(nonEmpty: "com.reddavis.meetinglights")!,
            accessibility: .afterFirstUnlock
        )
    }

    #if DEBUG || TEST
    static var mock: Valet {
        .valet(
            with: .init(nonEmpty: "com.reddavis.meetinglights-mock")!,
            accessibility: .afterFirstUnlock
        )
    }
    #endif
}
