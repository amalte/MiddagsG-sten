import Foundation

/// Non-persisted copy of Meal, used to avoid live persistence when editing meal (only persist on explicit save).
struct MealDraft {
    var name: String = ""
    var guest: String = ""
    var date: Date = .now
    var diet: String?
    var notes: String?

    init() {}

    init(from meal: Meal) {
        self.name = meal.name
        self.guest = meal.guest
        self.date = meal.date
        self.diet = meal.diet
        self.notes = meal.notes
    }
}
