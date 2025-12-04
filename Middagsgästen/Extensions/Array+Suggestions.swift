import Foundation

extension Array where Element == String {
    func suggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return [] }

        let unique = Array(Set(self))

        return unique
            .filter {
                $0.caseInsensitiveContains(query) &&
                !$0.caseInsensitiveEquals(query)
            }
            .sorted()
    }
}
