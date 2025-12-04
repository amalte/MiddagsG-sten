import SwiftUI

struct MealCardView: View {
    let meals: [Meal]
    let identifier: MealIdentifier
    var mealName: String {
        return meals.first?.name.capitalizingFirstLetter() ?? "Maträtten"
    }
    
    var displayText: Text {
        switch identifier {
        case .guest:
            return Text("Lagat \(meals.count) \(meals.count.plural("maträtt", "maträtter")) till denna gäst.")
        case .mealName:
            return Text("\(mealName) har lagats till \(meals.count) \(meals.count.plural("gäst", "gäster")).")
        }
    }
    
    @State private var showingMeals = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                displayText
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    withAnimation(.smooth) {
                        showingMeals.toggle()
                    }
                } label: {
                    Label(
                        showingMeals ? "Dölj" : "Visa",
                        systemImage: showingMeals ? "chevron.up" : "chevron.down"
                    )
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.blue)
                }
            }
            
            if showingMeals {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 6)]) {
                    ForEach(meals) { meal in
                        MealCardViewItem(meal: meal)
                    }
                }
            }
        }
    }
}

#Preview {
    MealCardView(
        meals: [
            Meal(name: "Pasta carbonara", guest: "Abraham Svensson", date: Date()),
            Meal(name: "Köttfärsås", guest: "Abraham Svensson", date: Date()),
            Meal(name: "Pannkakor", guest: "Abraham Svensson", date: Date())
        ],
        identifier: MealIdentifier.guest
    )
}
