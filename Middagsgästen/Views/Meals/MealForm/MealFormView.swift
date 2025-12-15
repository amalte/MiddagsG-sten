import SwiftData
import SwiftUI

/// Sheet for creating and editing a  meal, containing input fields for the meal.
struct MealFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var meals: [Meal]
    
    let mode: MealFormMode
    @State private var meal: Meal
    
    @State private var showValidationErrors = false
    
    @FocusState private var focusedField: Field?
    enum Field { case guest, mealName, diet, notes, date }
    
    var isGuestValid: Bool { !meal.guest.isBlank }
    var isMealNameValid: Bool { !meal.name.isBlank  }
    var isFormValid: Bool { isGuestValid && isMealNameValid }
    
    var shouldShowMealNameDuplicates: Bool {
        focusedField != .mealName && !meal.name.isEmpty && !mealNameDuplicates.isEmpty
    }
    var shouldShowGuestDuplicates: Bool {
        focusedField != .guest && !meal.guest.isEmpty && !guestDuplicates.isEmpty
    }
    var mealNameDuplicates: [Meal] { // Extract other meals with the same mealName
        meals.filter { $0.name.caseInsensitiveEquals(meal.name) && $meal.id != $0.id }
    }
    var guestDuplicates: [Meal] { // Extract other meals with the same guest
        meals.filter { $0.guest.caseInsensitiveEquals(meal.guest) && $meal.id != $0.id}
    }
    
    var guestSuggestions: [String] {
        meals.map(\.guest).suggestions(for: meal.guest)
    }
    var mealNameSuggestions: [String] {
        meals.map(\.name).suggestions(for: meal.name)
    }
    
    init(mode: MealFormMode) {
        self.mode = mode
        
        switch mode {
        case .add:
            _meal = State(initialValue: Meal(guest: "", name: "", date: .now))
        case .edit(let meal):
            _meal = State(initialValue: meal)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(mode.title)
                    .font(.title.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                VStack {
                    sectionTitle("Måltid")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    mealInputs
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
    
    private var mealInputs: some View {
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
    }
    
    // Input field for the "guest" textinput
    private var guestInput: some View {
        validatedAutoCompleteField(
            text: $meal.guest,
            placeholder: "Gäst",
            suggestions: focusedField == .guest ? guestSuggestions : [],
            isFocused: focusedField == .guest,
            isValid: isGuestValid,
            errorText: "Gäst är obligatoriskt",
            suggestionsDropdownView: {
                if shouldShowGuestDuplicates {
                    MealDropdownView(meals: guestDuplicates, identifier: .guest)
                }
            }
        )
        .focused($focusedField, equals: .guest)
    }
    
    // Input field for the "mealName" textinput
    private var mealNameInput: some View {
        validatedAutoCompleteField(
            text: $meal.name,
            placeholder: "Maträtt",
            suggestions: focusedField == .mealName ? mealNameSuggestions : [],
            isFocused: focusedField == .mealName,
            isValid: isMealNameValid,
            errorText: "Maträtt är obligatoriskt",
            suggestionsDropdownView: {
                if shouldShowMealNameDuplicates {
                    MealDropdownView(meals: mealNameDuplicates, identifier: .mealName)
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
            AutoCompleteField(
                text: $meal.diet.nonOptional(),
                placeholder: "Diet (valfritt)"
            )
            .focused($focusedField, equals: .diet)
            
            AutoCompleteField(
                text: $meal.notes.nonOptional(),
                placeholder: "Anteckningar (valfritt)"
            )
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
                    date: $meal.date,
                    range: Date.distantPast...Date.distantFuture
                )
                .frame(height: 60)
                .id(meal.date)
                .onChange(of: meal.date) {
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
        
        switch mode {
        case .add:
            let newMeal = Meal(guest: meal.guest, name: meal.name, date: meal.date,
                               diet: meal.diet,
                               notes: meal.notes
            )
            modelContext.insert(newMeal) // Adds the new meal to the list
            
        case .edit(let originalMeal):
            updateMeal(to: originalMeal) // Update the existing meal
        }
        dismiss()
    }

    private func updateMeal(to meal: Meal) {
        meal.guest = self.meal.guest
        meal.name = self.meal.name
        meal.date = self.meal.date
        meal.diet = self.meal.diet
        meal.notes = self.meal.notes
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
    MealFormView(mode: .add)
        .modelContainer(previewContainer)
}
