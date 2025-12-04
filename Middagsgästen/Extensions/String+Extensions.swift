import Foundation

extension String {
    func caseInsensitiveEquals(_ other: String) -> Bool {
        self.localizedCaseInsensitiveCompare(other) == .orderedSame
    }
    
    func caseInsensitiveContains(_ other: String) -> Bool {
        self.localizedCaseInsensitiveContains(other)
    }
    
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
