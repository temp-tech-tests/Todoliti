import Foundation

@MainActor
final class HomeScreenViewModel: ObservableObject {
    
    @Published var items: [TodoItem] = []
    @Published var hasError: Bool = false

    private let manager: any TodoManagerRepresentable

    init(manager: some TodoManagerRepresentable = TodoManager()) {
        self.manager = manager
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
                
                // call refresh
            } catch {
                // handle error
            }
        }
    }
}
