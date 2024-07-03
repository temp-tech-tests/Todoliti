import Foundation
import TodoService

protocol TodoManagerRepresentable {
    func createTask(title: String) async throws
}

final class TodoManager: TodoManagerRepresentable {
    
    enum TodoManagerError: Error {
        case failedToCreateItem
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
}
