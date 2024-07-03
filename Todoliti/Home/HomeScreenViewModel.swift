import Foundation

@MainActor
final class HomeScreenViewModel: ObservableObject {
    
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
            print(items)
        } catch {
            // Handle error
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
                // handle error
            }
        }
    }
}
