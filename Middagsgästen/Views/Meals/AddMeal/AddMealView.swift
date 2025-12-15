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
    
    var isGuestValid: Bool { !guest.isBlank }
    var isMealNameValid: Bool { !mealName.isBlank  }
    var isFormValid: Bool { isGuestValid && isMealNameValid }
    
    var shouldShowMealNameDuplicates: Bool {
        focusedField != .mealName && !mealName.isEmpty && !mealNameDuplicates.isEmpty
    }
    var shouldShowGuestDuplicates: Bool {
        focusedField != .guest && !guest.isEmpty && !guestDuplicates.isEmpty
    }
    var mealNameDuplicates: [Meal] { // Extract other meals with the same mealName
        meals.filter { $0.name.caseInsensitiveEquals(mealName) }
    }
    var guestDuplicates: [Meal] { // Extract other meals with the same guest
        meals.filter { $0.guest.caseInsensitiveEquals(guest) }
    }
    
    var guestSuggestions: [String] {
        meals.map(\.guest).suggestions(for: guest)
    }
    var mealNameSuggestions: [String] {
        meals.map(\.name).suggestions(for: mealName)
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
                        guestInput
                        Divider()
                            .padding(.leading, 16)
                            .padding(.top, showValidationErrors && !isGuestValid ? 8 : 16)
                            .padding(.bottom, 16)
                        mealNameInput
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, showValidationErrors && !isMealNameValid ? 8 : 16)
                    .roundEdgesCard()
                    
                    otherSection
                    
                    datePickerSection
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
    
    // Input field for the "guest" textinput
    private var guestInput: some View {
        validatedAutoCompleteField(
            text: $guest,
            placeholder: "Gäst",
            suggestions: focusedField == .guest ? guestSuggestions : [],
            isFocused: focusedField == .guest,
            isValid: isGuestValid,
            errorText: "Gäst är obligatoriskt",
            suggestionsDropdownView: {
                if shouldShowGuestDuplicates {
                    AddMealDropdownView(meals: guestDuplicates, identifier: MealIdentifier.guest)
                }
            }
        )
        .focused($focusedField, equals: .guest)
    }
    
    // Input field for the "mealName" textinput
    private var mealNameInput: some View {
        validatedAutoCompleteField(
            text: $mealName,
            placeholder: "Maträtt",
            suggestions: focusedField == .mealName ? mealNameSuggestions : [],
            isFocused: focusedField == .mealName,
            isValid: isMealNameValid,
            errorText: "Maträtt är obligatoriskt",
            suggestionsDropdownView: {
                if shouldShowMealNameDuplicates {
                    AddMealDropdownView(meals: mealNameDuplicates, identifier: MealIdentifier.mealName)
                }
            }
        )
        .focused($focusedField, equals: .mealName)
    }
    
    @ViewBuilder
    private var otherSection: some View {
        sectionTitle("Övrigt")
            .padding(.top, 20)
            .padding(.bottom, 4)
        VStack(spacing: 16) {
            AutoCompleteField(text: $diet, placeholder: "Diet (valfritt)")
            .focused($focusedField, equals: .diet)
            
            AutoCompleteField(text: $notes, placeholder: "Anteckningar (valfritt)")
            .focused($focusedField, equals: .notes)
        }
        .padding()
        .roundEdgesCard()
    }
    
    private var datePickerSection: some View {
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
        
        let newMeal = Meal(name: mealName, guest: guest, date: date,
            diet: diet.isEmpty ? nil : diet,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(newMeal) // Adds the new meal to the list
        dismiss()
    }
    
    // A textinput containing validation with error text showing if input is invalid,
    // textinput also shows autocomplete suggestions based on the inputted suggestions list.
    private func validatedAutoCompleteField(
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
    
    private func sectionTitle(_ text: String) -> some View {
          Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
      }
    
    private func validationErrorText(_ text: String) -> some View {
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
