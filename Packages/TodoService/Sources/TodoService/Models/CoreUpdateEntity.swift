import Foundation

public protocol CoreUpdateEntity {
    var identifier: UUID { get }
    var title: String { get }
    var details: String? { get }
    var coreStatus: CoreTodoItemStatus { get }
}
