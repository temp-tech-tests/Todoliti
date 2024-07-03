import Foundation

@MainActor
final class ItemDetailsScreenViewModel: ObservableObject {

    @Published var editingItem: EditingItem

    struct EditingItem: Equatable {
        var itemModel: TodoItem
        var editingTitle: String
        var editingDetails: String
    }

    init(todoItem: TodoItem) {
        self.editingItem = EditingItem(
            itemModel: todoItem,
            editingTitle: todoItem.title,
            editingDetails: todoItem.details ?? "")
    }

    func updateModel() {

    }
}
