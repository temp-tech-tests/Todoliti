import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false

    @EnvironmentObject private var viewModel: HomeScreenViewModel

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
            .overlay(alignment: .bottomTrailing) {
                if viewModel.featuresTask {
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .foregroundStyle(.white)
                            .background {
                                Circle()
                                    .fill(.blue)
                            }
                            .padding()
                            .shadow(radius: 3)
                    }.buttonStyle(PlainButtonStyle())
                }
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
    
    class MockManager: TodoManagerRepresentable {
        var tasks: [TodoItem] = []
        func createTask(title: String) async throws {
            tasks.append(TodoItem(id: UUID(), title: title, details: "details", createdDate: Date(), status: .todo))
        }
        
        func loadTasks() async throws -> [TodoItem] {
            return tasks
        }
    }

    return HomeScreen()
        .environmentObject(HomeScreenViewModel(manager: MockManager()))
}
