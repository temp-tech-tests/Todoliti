enum TodoItemStatus: Int {
    case todo
    case completed
}

extension TodoItemStatus {
    func toggle() -> TodoItemStatus{
        self == .todo ? .completed : .todo
    }
}
