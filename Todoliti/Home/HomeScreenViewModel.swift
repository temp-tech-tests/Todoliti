import Foundation

@MainActor
final class HomeScreenViewModel: ObservableObject {
    
    enum SortingOption {
        case date, status
    }

    @Published var showError: Bool = false
    @Published var sortingOption: SortingOption = .date
    @Published var items: [TodoItem] = []
    @Published var hasError: Bool = false

    var featuresTask: Bool {
        !items.isEmpty
    }

    private let manager: any TodoManagerRepresentable

    init(manager: some TodoManagerRepresentable = TodoManager()) {
        self.manager = manager
    }

    func loadItems() async {
        do {
            items = try await manager.loadTasks()
            updateSortingOption(sortingOption)
        } catch {
            showError = true
        }
    }

    func updateSortingOption(_ sortingOption: SortingOption) {
        switch sortingOption {
        case .date:
            items = items.sorted(by: { $0.createdDate > $1.createdDate })
        case .status:
            items = items.sorted(by: { $0.status < $1.status })
        }
    }

    func toggleItemState(_ item: TodoItem) {
        Task {
            let updatingModel = TodoItem(
                id: item.id,
                title: item.title,
                details: item.details,
                createdDate: item.createdDate,
                status: item.status.toggle())
            do {
                try await manager.updateTask(model: updatingModel)
                await loadItems()
            } catch {
                showError = true
            }
        }
    }

    func deleteItem(_ item: TodoItem) {
        Task {
            do {
                try await manager.deleteTask(model: item)
                await loadItems()
            } catch {
                showError = true
            }
        }
    }

    func createItem(title: String) {
        guard !title.isEmpty else {
            hasError = true
            return
        }

        hasError = false

        Task {
            do {
                try await manager.createTask(title: title)
                await loadItems()
            } catch {
                showError = true
            }
        }
    }
}
