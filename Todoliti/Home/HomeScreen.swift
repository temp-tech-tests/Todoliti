import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false

    @EnvironmentObject private var viewModel: HomeScreenViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                ItemCell(model: item) { cellAction in
                    handleCellAction(item: item, action: cellAction)
                }
                .swipeActions(edge: .leading) {
                    deleteButton(item: item)
                }
                .swipeActions(edge: .trailing) {
                    doneButton(item: item)
                }
            }
            .animation(.easeIn, value: viewModel.items)
            .listStyle(.plain)
            .navigationTitle("HOME_WELCOME")
            .task {
                await viewModel.loadItems()
            }
            .overlay(alignment: .bottomTrailing) {
                if viewModel.featuresTask {
                    addTaskButton
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

    private var addTaskButton: some View {
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

    private func deleteButton(item: TodoItem) -> some View {
        Button {
            viewModel.deleteItem(item)
        } label: {
            Text("DELETE")
        }.tint(.red)
    }

    @ViewBuilder
    private func doneButton(item: TodoItem) -> some View {
        let taskDone = item.coreStatus == .completed
        Button {
            viewModel.toggleItemState(item)
        } label: {
            Text(taskDone ? "TASK_TODO" : "VALIDATE")
        }.tint(taskDone ? .yellow : .green)
    }

    private func submit() {
        viewModel.createItem(title: newTaskName)
        resetTaskName()
    }

    private func resetTaskName() {
        newTaskName = ""
    }

    private func handleCellAction(item: TodoItem, action: ItemCell.ItemCellAction) {
        switch action {
        case .checked:
            viewModel.toggleItemState(item)
        case .tapped:
            break
        }
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

        func updateTask(model: TodoItem) async throws {
            guard let index = tasks.firstIndex(where: {$0.id == model.id}) else { return }
            tasks[index] = model
        }

        func deleteTask(model: TodoItem) async throws {
            tasks.removeAll(where: { $0.id == model.id })
        }
    }

    return HomeScreen()
        .environmentObject(HomeScreenViewModel(manager: MockManager()))
}
