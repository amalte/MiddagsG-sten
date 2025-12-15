import SwiftUI

/// View that is displayed when user has no meals added (e.g. on inital app launch).
struct BackgroundEmptyMealView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image("MiddagsGastenTransparent")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 250)
                .opacity(0.9)
            Text("Tryck på + knappen för att skapa en maträtt")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Spacer()
                .frame(height: 100)
        }
    }
}

#Preview {
    BackgroundEmptyMealView()
}
