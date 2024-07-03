import Foundation

/// Use this object to set-up a new item with ``TodoService`` or retrieve existing items.
public struct CoreTodoItem {
    
    public let title: String
    public let details: String?
    public let createdDate: Date

    enum ObjectKey: String {
        case title
        case details
        case createdDate
    }
}
