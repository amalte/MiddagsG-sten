
/// System name for all icons used in the app
enum AppSymbol: String {
    case guest = "person.fill"
    case mealName = "fork.knife"
    case diet = "leaf"
    case notes = "doc.text"
    case date = "calendar"
    case edit = "pencil"
    case delete = "trash"

    var systemName: String { rawValue }
}
