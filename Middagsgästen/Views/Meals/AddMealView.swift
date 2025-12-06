import SwiftData
import SwiftUI

struct AddMealView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var meals: [Meal]
    
    @State private var mealName = ""
    @State private var guest = ""
    @State private var date = Date()
    
    @FocusState private var focusedField: Field?
    enum Field { case guest, mealName, date }
    
    var mealNameDuplicates: [Meal] {
        meals.filter {
            $0.name.localizedCaseInsensitiveCompare(self.mealName) == .orderedSame
        }
    }
    
    var guestDuplicates: [Meal] {
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
                VStack {
                    Text("Ny maträtt")
                        .font(.title.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 16) { // INPUT FIELDS
                        AutoCompleteField(
                            text: $guest,
                            placeholder: "Gäst",
                            suggestions: focusedField == .guest ? guestSuggestions : [],
                            onSelect: { selected in guest = selected }
                        )
                        .focused($focusedField, equals: .guest)
                        
                        // "Visa/Dölj" Show the MealCardView.swift view
                        if focusedField != .guest && !guest.isEmpty && !guestDuplicates.isEmpty {
                            MealCardView(meals: guestDuplicates, identifier: MealIdentifier.guest)
                        }
                        Divider().padding(.leading, 16)
                        
                        AutoCompleteField(
                            text: $mealName,
                            placeholder: "Maträtt",
                            suggestions: focusedField == .mealName ? mealNameSuggestions : [],
                            onSelect: { selected in mealName = selected }
                        )
                        .focused($focusedField, equals: .mealName)
                        
                        if focusedField != .mealName && !mealName.isEmpty && !mealNameDuplicates.isEmpty {
                            MealCardView(meals: mealNameDuplicates, identifier: MealIdentifier.mealName)
                        }
                        Divider().padding(.leading, 16)
                        
                        DatePicker(
                            "Datum",
                            selection: $date,
                            displayedComponents: .date
                        )
                        .id(date)
                        .onChange(of: date) {
                            focusedField = .date
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Avbryt") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Spara") {
                            let newMeal = Meal(name: mealName, guest: guest, date: date)
                            modelContext.insert(newMeal) // Adds the new meal to the list
                            dismiss()
                        }
                    }
                }
            }
            .onTapGesture { focusedField = nil } // dismiss focus when tapping outside
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    AddMealView()
        .modelContainer(previewContainer)
}
