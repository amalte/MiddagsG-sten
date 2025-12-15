import Foundation
import SwiftData

/// Predefined meals data used for testing purposes.
enum PreviewData {
    static let meals: [Meal] = [
        Meal(guest: "Göran", name: "Carbonara", date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        Meal(guest: "Göran", name: "Pizza", date: .now),
        Meal(guest: "Göran", name: "Köttbullar", date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!),
        Meal(guest: "Göran", name: "Chicken nuggets", date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!),
        Meal(guest: "Eriksson", name: "Köttbullar", date: Calendar.current.date(byAdding: .day, value: -100, to: .now)!),
        Meal(guest: "Eriksson", name: "Hamburgare", date: .now, diet: "nötter, vegeterian", notes: "Gott, recept: https://www.ica.se/recept/hamburgare-712808/"),
        Meal(guest: "Farmor", name: "Lax i ugn", date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!),
        Meal(guest: "Malte", name: "Pannkakor med sylt och grädde", date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        Meal(guest: "Malte", name: "Pannkakor", date: .now),
    ]
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Meal.self, configurations: config)
        
        for meal in PreviewData.meals {
            container.mainContext.insert(meal)
        }
        return container
        
    } catch {
        fatalError("Failed to create container.")
    }
}()
