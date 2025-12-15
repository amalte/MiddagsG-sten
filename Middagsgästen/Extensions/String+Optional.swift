import SwiftUI

extension Binding where Value == String? {
    func nonOptional(_ fallback: String = "") -> Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? fallback },
            set: { newValue in
                self.wrappedValue = newValue.isEmpty ? nil : newValue }
        )
    }
}
