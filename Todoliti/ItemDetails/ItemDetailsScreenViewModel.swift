import Foundation

@MainActor
final class ItemDetailsScreenViewModel: ObservableObject {

    @Published var showError: Bool = false
    @Published var editingItem: EditingItem

    struct EditingItem: Equatable {
        var itemModel: TodoItem
        var editingTitle: String
        var editingDetails: String
        var editingStatus: TodoItemStatus
    }

    private let manager: any TodoManagerRepresentable

    init(todoItem: TodoItem, manager: some TodoManagerRepresentable = TodoManager()) {
        self.editingItem = EditingItem(
            itemModel: todoItem,
            editingTitle: todoItem.title,
            editingDetails: todoItem.details ?? "",
            editingStatus: todoItem.status)
        self.manager = manager
    }

    func deleteItem() async {
        do {
            try await manager.deleteTask(model: editingItem.itemModel)
        } catch {
            showError = true
        }
    }

    func updateModel() {
        Task {
            do {
                try await manager.updateTask(model: TodoItem(
                    id: editingItem.itemModel.id,
                    title: editingItem.editingTitle,
                    details: editingItem.editingDetails.isEmpty ? nil : editingItem.editingDetails,
                    createdDate: editingItem.itemModel.createdDate,
                    status: editingItem.editingStatus))
            } catch {
                showError = true
            }
        }
    }
}
