import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false

    @StateObject private var viewModel = HomeScreenViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {

            }
            .navigationTitle("HOME_WELCOME")
            .overlay {
                NoTaskContentView {
                    showAlert = true
                }
            }
            .newTaskAlert(
                text: $newTaskName,
                show: $showAlert,
                onSubmit: submit)
        }
    }

    private func submit() {
        viewModel.createItem(title: newTaskName)
    }
}

#Preview {
    HomeScreen()
}
