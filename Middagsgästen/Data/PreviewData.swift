import Foundation
import SwiftData

/// Predefined meals data used for testing purposes.
enum PreviewData {
    static let meals: [Meal] = [
        Meal(name: "Carbonara", guest: "Göran", date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        Meal(name: "Pizza", guest: "Göran", date: .now),
        Meal(name: "Köttbullar", guest: "Göran", date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!),
        Meal(name: "Chicken nuggets", guest: "Göran", date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!),
        Meal(name: "Köttbullar", guest: "Eriksson", date: Calendar.current.date(byAdding: .day, value: -100, to: .now)!),
        Meal(name: "Hamburgare", guest: "Eriksson", date: .now, diet: "nötter, vegeterian", notes: "Gott, recept: https://www.ica.se/recept/hamburgare-712808/"),
        Meal(name: "Lax i ugn", guest: "Farmor", date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!),
        Meal(name: "Pannkakor med sylt och grädde", guest: "Malte", date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        Meal(name: "Pannkakor", guest: "Malte", date: .now),
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
