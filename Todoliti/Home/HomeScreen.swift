import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false

    @StateObject private var viewModel = HomeScreenViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                ItemCell(model: item) { _ in
                    // ..
                }
            }
            .listStyle(.plain)
            .navigationTitle("HOME_WELCOME")
            .task {
                await viewModel.loadItems()
            }
            .overlay {
                if !viewModel.featuresTask {
                    NoTaskContentView {
                        showAlert = true
                    }
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
