import SwiftData
import SwiftUI

struct MealsListView: View {
    @State private var searchText = ""
    @State private var isPresentingAddMealSheet = false
    
    let meals: [Meal]

    var filteredMeals: [Meal] {
        searchText.isEmpty ? meals :
        meals.filter { meal in
            meal.name.localizedCaseInsensitiveContains(searchText) ||
            meal.guest.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            Group {
                if filteredMeals.isEmpty {
                    ContentUnavailableView(
                        "Din sökning matchade inte med någon maträtt eller gäst",
                        systemImage: "magnifyingglass",
                        description: Text("Testa ett annat namn på maträtt eller gästnamn")
                    )
                } else {
                    List(filteredMeals) { meal in
                        MealCardViewItem(meal: meal)
                    }
                }
            }
            .navigationTitle("Matgästen")
            .searchable(text: $searchText, prompt: "Sök efter maträtt eller gäster")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddMealSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddMealSheet) {
                AddMealView(meals: meals)
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        MealsListView(meals: PreviewData.meals)
            .modelContainer(previewContainer)
    }
}
