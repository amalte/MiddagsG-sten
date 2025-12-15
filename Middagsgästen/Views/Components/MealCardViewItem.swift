import SwiftUI

/// Displays a meal as a simple card.
struct MealCardViewItem: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "person.fill")
                    .padding(.top, 1)
                Text(meal.guest)
            }
            .font(.headline)
            
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "fork.knife")
                    .padding(.top, 1)
                Text(meal.name)
                    .foregroundColor(.secondary)
            }
            
            if let diet = meal.diet {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "leaf")
                        .padding(.top, 1)
                    Text(diet)
                }
                .foregroundColor(.secondary)
            }
            
            if let notes = meal.notes {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "doc.text")
                        .padding(.top, 1)
                    Text(notes)
                }
                .foregroundColor(.secondary)
            }

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "calendar")
                    .padding(.top, 1)
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
        meal: Meal(guest: "Abraham Svensson", name: "Pasta carbonara", date: Date(), diet: "potatis, vegan", notes: "God mat som smakar gott mycket gott mycket mycket mycket mycket gott gott gott gott.")
    )
}
