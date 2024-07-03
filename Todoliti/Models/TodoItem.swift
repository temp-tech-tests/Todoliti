import Foundation

struct TodoItem: Identifiable, Equatable, Hashable {
    let id: UUID
    let title: String
    let details: String?
    let createdDate: Date
    let status: TodoItemStatus
}
