import SwiftUI

/// View that is displayed when user has no meals added (e.g. on inital app launch).
struct BackgroundEmptyMealView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("MiddagsGastenTransparent")
                .resizable()
                .scaledToFit()
            Text("Skapa en maträtt genom att trycka på '+' knappen")
                .font(.title)
                .padding(.horizontal, 40)
            Spacer()
                .frame(height: 80)
        }
    }
}

#Preview {
    BackgroundEmptyMealView()
}
