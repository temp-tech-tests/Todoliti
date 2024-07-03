/// An enum describing possible errors while using ``TodoService``.
public enum TodoServiceError: Error {
    case failedToCreateEntity
    case failedToFetchEntities
    case failedToDeleteAnItem
    case itemNotFound
}
