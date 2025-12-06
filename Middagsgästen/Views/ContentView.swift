import SwiftData
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
        .modelContainer(previewContainer)
}

