import SwiftUI

/// A text input field with selectable autocomplete for existing meals/guests.
struct AutoCompleteField: View {
    @Binding var text: String
    let placeholder: String
    let suggestions: [String]?
    let onSelect: ((String) -> Void)?
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        suggestions: [String]? = nil,
        onSelect: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.suggestions = suggestions
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.15), lineWidth: 1) // border
                        )
                )

            if isFocused, !text.isEmpty, let suggestions = suggestions, !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .onTapGesture {
                                onSelect?(suggestion)
                                isFocused = false
                            }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
            }
        }
    }
}
    
#Preview {
    AutoCompleteField(
        text: .constant("Hello"),
        placeholder: "Placeholder text",
        suggestions: ["Swift", "iOS", "macOS"],
        onSelect: { selected in }
    )
}
