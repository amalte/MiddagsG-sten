import SwiftUI

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let self, !self.isEmpty else { return nil }
        return self
    }
}

extension Binding where Value == String? {
    func nonOptional(_ fallback: String = "") -> Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? fallback },
            set: { newValue in
                self.wrappedValue = newValue.isEmpty ? nil : newValue }
        )
    }
}
