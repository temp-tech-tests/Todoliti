import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let details: String?
    let createdDate: Date
    let status: TodoItemStatus
}
