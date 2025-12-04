import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Meal.date, order: .reverse),
        SortDescriptor(\Meal.guest)
    ]) var meals: [Meal]
    
    var body: some View {
        NavigationStack {
            MealsListView(meals: meals)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}

