import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {

            }
            .navigationTitle("HOME_WELCOME")
            .overlay {
                noTaskContentView
            }
            .alert("HOME_CREATE_TASK_TITLE", isPresented: $showAlert) {
                TextField("HOME_CREATE_TASK_TEXT_PLACEHOLDER", text: $newTaskName)
                Button("VALIDATE", action: submit)
            } message: {
                Text("HOME_CREATE_TASK_MESSAGE")
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
                showAlert = true
            } label: {
                Label("HOME_NEW_TASK", systemImage: "plus.circle.fill")
            }.buttonStyle(BorderedProminentButtonStyle())

        }.padding(26)
    }

    private func submit() {
        
    }
}

#Preview {
    HomeScreen()
}
