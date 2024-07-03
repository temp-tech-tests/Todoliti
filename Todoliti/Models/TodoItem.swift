import Foundation

struct TodoItem: Identifiable {
    let id: UUID
    let title: String
    let details: String?
    let createdDate: Date
    let status: TodoItemStatus
}
