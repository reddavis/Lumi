import Foundation

enum WindowGroupIdentifier: String {
    case setup
    
    var url: URL {
        URL(string: "lumi://\(self.rawValue)")!
    }
}
