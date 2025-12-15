import SwiftData
import SwiftUI

/// Main screen of app, displays a list of all the meals with add, delete and search functionality.
struct MealsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Meal.date, order: .reverse),
        SortDescriptor(\Meal.guest)
    ]) var meals: [Meal]
    
    @State private var searchText = ""
    @State private var isPresentingAddMealSheet = false
    @State private var isShowingDeleteConfirmation = false
    @State private var mealPendingDelete: Meal?

    var filteredMeals: [Meal] {
        searchText.isEmpty ? meals :
        meals.filter { meal in
            meal.name.localizedCaseInsensitiveContains(searchText) ||
            meal.guest.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            Group {
                // No meals exist, show empty meal view
                if meals.isEmpty {
                    BackgroundEmptyMealView()
                }
                // Display no search result, search has no matches
                else if filteredMeals.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView(
                        "Din sökning matchade inte med någon maträtt eller gäst",
                        systemImage: "magnifyingglass",
                        description: Text("Testa ett annat namn på maträtt eller gäst")
                    )
                }
                // Display meals, filtered if search is used otherwise all
                else {
                    List {
                        ForEach(filteredMeals) { meal in
                            MealCardViewItem(meal: meal)
                            .swipeActions {
                                Button("", systemImage: "trash") {
                                    mealPendingDelete = meal
                                    isShowingDeleteConfirmation = true
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .animation(.default, value: filteredMeals)
                }
            }
            .alert(
                "Ta bort maträtt?",
                isPresented: $isShowingDeleteConfirmation
            ) {
                Button("Ta bort", role: .destructive) {
                    if let meal = mealPendingDelete {
                         withAnimation {
                             deleteMealConfirmed(meal)
                         }
                    }
                }
                
                Button("Avbryt", role: .cancel) {
                    mealPendingDelete = nil
                }
            }
            .navigationTitle("Middagsgästen")
            .searchable(text: $searchText, prompt: "Sök efter maträtt eller gäster")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddMealSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddMealSheet) {
                AddMealView()
            }
            
        }
    }
    
    private func deleteMealConfirmed(_ meal: Meal) {
            modelContext.delete(meal)
        mealPendingDelete = nil
    }
}

#Preview {
    NavigationStack {
        MealsListView()
            .modelContainer(previewContainer)
    }
}
