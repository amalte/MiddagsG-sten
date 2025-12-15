import Foundation

/// Mode to know if adding or editing a meal.
enum MealFormMode: Identifiable {
    case add
    case edit(Meal)
    
    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let meal):
            return meal.id.uuidString
        }
    }
    
    var isEdit: Bool {
        if case .edit = self { return true }
        return false
    }
    
    var meal: Meal? {
        if case let .edit(meal) = self {
            return meal
        }
        return nil
    }
    
    var title: String {
        isEdit ? "Redigera maträtt" : "Ny maträtt"
    }
}
