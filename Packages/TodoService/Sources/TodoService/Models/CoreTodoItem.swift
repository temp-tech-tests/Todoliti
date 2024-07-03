import Foundation

public enum CoreTodoItemStatus: Int {
    case todo
    case completed
}

/// Use this object to set-up a new item with ``TodoService`` or retrieve existing items.
public struct CoreTodoItem {
    
    public let identifier: UUID
    public let title: String
    public let details: String?
    public let createdDate: Date
    public let status: CoreTodoItemStatus

    enum ObjectKey: String {
        case identifier
        case title
        case details
        case createdDate
        case status
    }
}
