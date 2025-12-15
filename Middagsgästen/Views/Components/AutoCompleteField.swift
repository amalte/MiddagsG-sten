import SwiftUI

/// A text input field with selectable autocomplete for existing meals/guests.
struct AutoCompleteField: View {
    @Binding var text: String
    let icon: AppSymbol
    let placeholder: String
    let suggestions: [String]?
    let onSelect: ((String) -> Void)?
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        icon: AppSymbol,
        placeholder: String,
        suggestions: [String]? = nil,
        onSelect: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.icon = icon
        self.placeholder = placeholder
        self.suggestions = suggestions
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Image(systemName: icon.systemName)
                    .padding(12)
                
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    
            }
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
                            .padding(.top, 10)
                            .padding(.leading, 44)
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
        icon: .date,
        placeholder: "Placeholder text",
        suggestions: ["Swift", "iOS", "macOS"],
        onSelect: { selected in }
    )
}
