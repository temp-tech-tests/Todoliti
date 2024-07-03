import Foundation
import TodoService

protocol TodoManagerRepresentable {
    func createTask(title: String) async throws
    func loadTasks() async throws -> [TodoItem]
    func updateTask(model: TodoItem) async throws
}

final class TodoManager: TodoManagerRepresentable {
    
    enum TodoManagerError: Error {
        case failedToCreateItem
        case failedToLoadItem
        case failedToUpdateItem
    }

    private let service: TodoService

    init(service: TodoService = TodoService()) {
        self.service = service
    }

    func createTask(title: String) async throws {
        do {
            try await service.createItem(title: title, details: nil)
        } catch {
            throw TodoManagerError.failedToCreateItem
        }
    }

    func loadTasks() async throws -> [TodoItem] {
        do {
            let coreItems = try await service.retrieveItems()
            return coreItems.map(\.asClientItem)
        } catch {
            throw TodoManagerError.failedToLoadItem
        }
    }

    func updateTask(model: TodoItem) async throws {
        do {
            try await service.updateEntity(updateEntity: model)
        } catch {
            throw TodoManagerError.failedToUpdateItem
        }
    }
}

extension TodoItem: CoreUpdateEntity {
    var identifier: UUID {
        id
    }

    var coreStatus: CoreTodoItemStatus {
        .init(rawValue: status.rawValue) ?? .todo
    }
}

private extension CoreTodoItem {
    var asClientItem: TodoItem {
        TodoItem(
            id: identifier,
            title: title,
            details: details,
            createdDate: createdDate,
            status: TodoItemStatus(rawValue: status.rawValue) ?? .todo)
    }
}
