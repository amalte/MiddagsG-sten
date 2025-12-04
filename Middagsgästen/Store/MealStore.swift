import Observation

@Observable
class MealStore {
    var meals: [Meal] = []
    
    init(_ meals: [Meal] = []) {
        self.meals = meals
    }
    
    func add(_ meal: Meal) {
        meals.append(meal)
    }
}
