enum TodoItemStatus: Int {
    case todo
    case completed
}

extension TodoItemStatus: Comparable {
    static func < (lhs: TodoItemStatus, rhs: TodoItemStatus) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension TodoItemStatus {
    func toggle() -> TodoItemStatus{
        self == .todo ? .completed : .todo
    }
}
