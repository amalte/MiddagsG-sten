import SwiftData
import SwiftUI

@main
struct MiddagsgastenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Meal.self)
    }
}
