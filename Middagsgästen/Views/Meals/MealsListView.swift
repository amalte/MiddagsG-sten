import SwiftUI

struct MealsListView: View {
    @State private var searchText = ""
    let meals: [Meal]

    var filteredMeals: [Meal] {
        searchText.isEmpty ?
        meals :
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
                        VStack(alignment: .leading) {
                            Text(meal.name).font(.headline)
                            Text("Gäst: \(meal.guest)").foregroundColor(.secondary)
                            Text("Datum: \(meal.formattedDate)").foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Matgästen")
            .searchable(text: $searchText, prompt: "Sök efter maträtt eller gäster")
            
        }
    }
}

#Preview {
    NavigationStack {
        MealsListView(meals: SampleData.meals)
    }
}
