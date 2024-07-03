import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {

            }
            .navigationTitle("HOME_WELCOME")
            .overlay {
                noTaskContentView
            }
        }
    }

    private var noTaskContentView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.square.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.blue)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.tertiary)
                }

            Text("HOME_NO_TASK")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Button {
                // ..
            } label: {
                Label("HOME_NEW_TASK", systemImage: "plus.circle.fill")
            }.buttonStyle(BorderedProminentButtonStyle())

        }.padding(26)
    }
}

#Preview {
    HomeScreen()
}
