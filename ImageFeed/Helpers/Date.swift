
import Foundation

extension Date {
    var formatted: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: self)
        }
    }
}
