import SwiftUI

struct ContentView: View {
    let meals: [Meal]
    
    var body: some View {
        NavigationStack {
            MealsListView(meals: meals)
        }
    }
}

#Preview {
    ContentView(meals: SampleData.meals)
}

