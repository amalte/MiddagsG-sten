import Foundation

struct Meal: Codable, Identifiable {
    var id = UUID()
    let name: String // name of the meal
    let guest: String // guest the meal was made for
    let date: Date // date the meal was cooked
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
