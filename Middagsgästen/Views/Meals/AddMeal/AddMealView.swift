import SwiftData
import SwiftUI

/// Sheet for creating a new meal, containing input fields for the meal.
struct AddMealView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var meals: [Meal]
    
    @State private var mealName = ""
    @State private var guest = ""
    @State private var diet = ""
    @State private var notes = ""
    @State private var date = Date()
    
    @State private var showValidationErrors = false
    
    @FocusState private var focusedField: Field?
    enum Field { case guest, mealName, diet, notes, date }
    
    var isGuestValid: Bool { !guest.trimmingCharacters(in: .whitespaces).isEmpty }
    var isMealNameValid: Bool { !mealName.trimmingCharacters(in: .whitespaces).isEmpty }
    var isFormValid: Bool { isGuestValid && isMealNameValid }
    
    var mealNameDuplicates: [Meal] { // Extract other meals with the same mealName
        meals.filter {
            $0.name.localizedCaseInsensitiveCompare(self.mealName) == .orderedSame
        }
    }
    var guestDuplicates: [Meal] { // Extract other meals with the same guest
        meals.filter {
            $0.guest.localizedCaseInsensitiveCompare(self.guest) == .orderedSame
        }
    }
    
    var guestSuggestions: [String] {
        let allGuests = meals.map { $0.guest }
        return allGuests.suggestions(for: guest)
    }
    var mealNameSuggestions: [String] {
        let allNames = meals.map { $0.name }
        return allNames.suggestions(for: mealName)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Ny maträtt")
                    .font(.title.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                VStack {
                    
                    sectionTitle("Måltid")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    VStack(spacing: 0) {
                        
                        // Input field for the "guest" textinput
                        validatedAutoCompleteTextInput(
                            text: $guest,
                            placeholder: "Gäst",
                            suggestions: focusedField == .guest ? guestSuggestions : [],
                            isFocused: focusedField == .guest,
                            isValid: isGuestValid,
                            errorText: "Gäst är obligatoriskt",
                            suggestionsDropdownView: {
                                if focusedField != .guest && !guest.isEmpty && !guestDuplicates.isEmpty {
                                    AddMealDropdownView(meals: guestDuplicates, identifier: MealIdentifier.guest)
                                }
                            }
                        )
                        .focused($focusedField, equals: .guest)
                        
                        Divider()
                            .padding(.leading, 16)
                            .padding(.top, showValidationErrors && !isGuestValid ? 8 : 16)
                            .padding(.bottom, 16)
                        
                        // Input field for the "mealName" textinput
                        validatedAutoCompleteTextInput(
                            text: $mealName,
                            placeholder: "Maträtt",
                            suggestions: focusedField == .mealName ? mealNameSuggestions : [],
                            isFocused: focusedField == .mealName,
                            isValid: isMealNameValid,
                            errorText: "Maträtt är obligatoriskt",
                            suggestionsDropdownView: {
                                if focusedField != .mealName && !mealName.isEmpty && !mealNameDuplicates.isEmpty {
                                    AddMealDropdownView(meals: mealNameDuplicates, identifier: MealIdentifier.mealName)
                                }
                            }
                        )
                        .focused($focusedField, equals: .mealName)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, showValidationErrors && !isMealNameValid ? 8 : 16)
                    .roundEdgesCard()
                    
                    sectionTitle("Övrigt")
                        .padding(.top, 20)
                        .padding(.bottom, 4)
                    VStack(spacing: 16) {
                        AutoCompleteField(
                            text: $diet,
                            placeholder: "Diet (valfritt)"
                        )
                        .focused($focusedField, equals: .diet)
                        
                        AutoCompleteField(
                            text: $notes,
                            placeholder: "Anteckningar (valfritt)"
                        )
                        .focused($focusedField, equals: .notes)
                    }
                    .padding()
                    .roundEdgesCard()
                    
                    
                    VStack {
                        HStack {
                            Text("Datum")
                            FullFormatDatePicker(
                                date: $date,
                                range: Date.distantPast...Date.distantFuture
                            )
                            .frame(height: 60)
                            .id(date)
                            .onChange(of: date) {
                                focusedField = .date
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .roundEdgesCard()
                    .padding(.top, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Spara", action: save)
                }
            }
            .onTapGesture { focusedField = nil } // dismiss focus when tapping outside
            .background(Color(.systemGroupedBackground))
        }
    }
    
    /// Save a newly created meal
    private func save() {
        // Validate form
        guard isFormValid else {
            showValidationErrors = true
            // Auto focus the invalid field
            if !isGuestValid {
                focusedField = .guest
            } else if !isMealNameValid {
                focusedField = .mealName
            }
            return
        }
        
        let newMeal = Meal(
            name: mealName,
            guest: guest,
            date: date,
            diet: diet.isEmpty ? nil : diet,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(newMeal) // Adds the new meal to the list
        dismiss()
    }
    
    // A textinput containing validation with error text showing if input is invalid,
    // textinput also shows autocomplete suggestions based on the inputted suggestions list.
    @ViewBuilder
    func validatedAutoCompleteTextInput(
        text: Binding<String>,
        placeholder: String,
        suggestions: [String],
        isFocused: Bool,
        isValid: Bool,
        errorText: String,
        @ViewBuilder suggestionsDropdownView: () -> some View
    ) -> some View {
        
        VStack(spacing: 0) {
            AutoCompleteField(
                text: text,
                placeholder: placeholder,
                suggestions: isFocused ? suggestions : [],
                onSelect: { text.wrappedValue = $0 }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(showValidationErrors && !isValid ? .red : .clear, lineWidth: 1)
            )

            if showValidationErrors && !isValid {
                validationErrorText(errorText)
            }

            suggestionsDropdownView()
                .padding(.top, 12)
        }
    }
    
    func sectionTitle(_ text: String) -> some View {
          Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
      }
    
    func validationErrorText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }
}

extension View {
    func roundEdgesCard() -> some View {
        self
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }
}

#Preview {
    AddMealView()
        .modelContainer(previewContainer)
}
