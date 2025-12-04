import SwiftUI

// Displays a single meal as a card
struct MealCardViewItem: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meal.name)
                .font(.headline)

            HStack(spacing: 6) {
                Image(systemName: "person.fill")
                Text(meal.guest)
            }
            .foregroundColor(.secondary)

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                Text(meal.formattedDate)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    MealCardViewItem(
        meal: Meal(name: "Pasta carbonara", guest: "Abraham Svensson", date: Date())
    )
}
