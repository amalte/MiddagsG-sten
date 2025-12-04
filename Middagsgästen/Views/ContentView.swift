import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            MealsListView()
        }
    }
}

#Preview {
    ContentView()
        .environment(MealStore(PreviewData.meals))
}

