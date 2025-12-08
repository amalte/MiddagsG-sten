import Foundation
import SwiftData

/// A persisted model representing a meal that was cooked for a certain guest, containing the cooking date.
@Model
class Meal {
    var id = UUID()
    var name: String // name of the meal
    var guest: String // guest the meal was made for
    var date: Date // date the meal was cooked
    var diet: String? // any allergies or if the guest is vegan for example
    var notes: String? // optional notes for the meal
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(name: String, guest: String, date: Date, diet: String? = nil, notes: String? = nil) {
        self.name = name
        self.guest = guest
        self.date = date
        self.diet = diet
        self.notes = notes
    }
}
