import SwiftUI

struct HomeScreen: View {

    @State private var newTaskName: String = ""
    @State private var showAlert: Bool = false
    @State private var path: [TodoItem] = []

    @EnvironmentObject private var viewModel: HomeScreenViewModel

    var body: some View {
        NavigationStack(path: $path) {
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
            .toolbar {
                if viewModel.featuresTask {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker(selection: $viewModel.sortingOption, label: Text("")) {
                                Text("HOME_SORTING_COMPLETE")
                                    .tag(HomeScreenViewModel.SortingOption.status)
                                Text("HOME_SORTING_DATES")
                                    .tag(HomeScreenViewModel.SortingOption.date)
                            }
                        } label: {
                            Label("", systemImage: "ellipsis.circle")
                        }
                    }
                }
            }
            .onChange(of: viewModel.sortingOption) { _, newValue in
                viewModel.updateSortingOption(newValue)
            }
            .animation(.easeIn, value: viewModel.items)
            .listStyle(.plain)
            .navigationTitle("HOME_WELCOME")
            .task {
                await viewModel.loadItems()
            }
            .searchable(text: $viewModel.searchText, prompt: "SEARCH_PLACEHOLDER")
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.searchItems()
            }
            .disabled(!viewModel.featuresTask)
            .overlay(alignment: .bottomTrailing) {
                if viewModel.featuresTask, !viewModel.isInSearchMode {
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
            .errorToast(model: .defaultError, show: $viewModel.showError)
            .newTaskAlert(
                text: $newTaskName,
                show: $showAlert,
                onSubmit: submit)
            .navigationDestination(for: TodoItem.self) { item in
                ItemDetailsScreen(path: $path)
                    .environmentObject(ItemDetailsScreenViewModel(todoItem: item))
            }
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
            path = [item]
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
