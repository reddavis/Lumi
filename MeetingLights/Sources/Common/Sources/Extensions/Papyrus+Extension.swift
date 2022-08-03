import Foundation
import Papyrus

extension PapyrusStore {
    static var main: PapyrusStore {
        PapyrusStore()
    }

    #if DEBUG || TEST
    static var mock: PapyrusStore {
        let temporaryDirectoryURL = URL(
            fileURLWithPath: NSTemporaryDirectory(),
            isDirectory: true
        )

        let url = temporaryDirectoryURL.appendingPathComponent(
            UUID().uuidString,
            isDirectory: true
        )

        return PapyrusStore(url: url)
    }
    #endif
}
