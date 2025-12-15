extension Meal {
    func apply(_ draft: MealDraft) {
        name = draft.name
        guest = draft.guest
        date = draft.date
        diet = draft.diet.nilIfEmpty
        notes = draft.notes.nilIfEmpty
    }
}

extension MealDraft {
    func toMeal() -> Meal {
        Meal(
            guest: guest,
            name: name,
            date: date,
            diet: diet,
            notes: notes
        )
    }
}
