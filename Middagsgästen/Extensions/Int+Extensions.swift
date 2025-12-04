import Foundation

extension Int {
    func plural(_ singular: String, _ plural: String) -> String {
        self == 1 ? singular : plural
    }
}
