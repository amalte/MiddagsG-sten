import Foundation
import SwiftData

/// A persisted model representing a meal that was cooked for a certain guest, containing the cooking date.
@Model
class Meal {
    var id = UUID()
    var guest: String // guest the meal was made for
    var name: String // name of the meal
    var date: Date // date the meal was cooked
    var diet: String? // any allergies or if the guest is vegan for example
    var notes: String? // optional notes for the meal
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(guest: String, name: String, date: Date, diet: String? = nil, notes: String? = nil) {
        self.guest = guest
        self.name = name
        self.date = date
        self.diet = diet
        self.notes = notes
    }
}
