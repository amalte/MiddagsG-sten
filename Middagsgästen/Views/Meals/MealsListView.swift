import SwiftData
import SwiftUI

/// Main screen of app, displays a list of all the meals with add, delete and search functionality.
struct MealsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Meal.date, order: .reverse),
        SortDescriptor(\Meal.guest)
    ]) private var meals: [Meal]
    
    @State private var searchText = ""
    @State private var isAddMealSheetPresented = false
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
            // No meals exist, show empty meal view
            if meals.isEmpty && searchText.isEmpty {
                BackgroundEmptyMealView()
            }
            // Display no search result, search has no matches
            else if filteredMeals.isEmpty && !searchText.isEmpty {
                noSearchResultsView
            }
            // Display meals, filtered if search is used otherwise all
            else { mealsList }
        }
        .navigationTitle("Middagsgästen")
        .searchable(text: $searchText, prompt: "Sök efter maträtt eller gäster")
        .toolbar { addButton }
        .sheet(isPresented: $isAddMealSheetPresented) {
            AddMealView()
        }
        .alert("Ta bort maträtt?", isPresented: $isShowingDeleteConfirmation) {
            deleteAlertButtons
        }
    }
    
    private var noSearchResultsView: some View {
        ContentUnavailableView(
            "Din sökning matchade inte med någon maträtt eller gäst",
            systemImage: "magnifyingglass",
            description: Text("Testa ett annat namn")
        )
    }
    
    private var mealsList: some View {
        List {
            ForEach(filteredMeals) { meal in
                MealCardViewItem(meal: meal)
                    .swipeActions {
                        deleteButton(for: meal)
                    }
            }
        }
        .animation(.default, value: filteredMeals)
    }

    private func deleteButton(for meal: Meal) -> some View {
        Button("", systemImage: "trash") {
            mealPendingDelete = meal
            isShowingDeleteConfirmation = true
        }
        .tint(.red)
    }
    
    private var addButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isAddMealSheetPresented = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    @ViewBuilder
    private var deleteAlertButtons: some View {
        Button("Ta bort", role: .destructive) {
            if let meal = mealPendingDelete {
                withAnimation {
                    modelContext.delete(meal)
                    mealPendingDelete = nil
                }
            }
        }

        Button("Avbryt", role: .cancel) { mealPendingDelete = nil }
    }
}

#Preview {
    NavigationStack {
        MealsListView()
            .modelContainer(previewContainer)
    }
}
