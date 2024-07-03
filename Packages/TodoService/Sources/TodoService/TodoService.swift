import Foundation
import CoreData

/// Use this object to perform CRUD operations for your todo items.
public final class TodoService {

    private enum Constant {
        static let containerName = "TodoServiceModel"
        static let modelExtension = "momd"
        static let todoItemEntityName = "TodoItemEntity"
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        guard let url = Bundle.module.url(forResource: Constant.containerName, withExtension: Constant.modelExtension),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to create managed object model")
        }

        let container = NSPersistentContainer(name: Constant.containerName, managedObjectModel: model)
        if let storeDescription {
            container.persistentStoreDescriptions = [storeDescription]
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private let storeDescription: NSPersistentStoreDescription?

    /// Main initializer for ``TodoService``
    ///
    /// - Parameters:
    ///     - storeDescription: A custom store description to pass to ``TodoService`` for unit testing for instance.
    public init(storeDescription: NSPersistentStoreDescription? = nil) {
        self.storeDescription = storeDescription
    }

    /// Use this method to add a todo item to the items list.
    ///
    /// - Parameters:
    ///     - title: The title of the task.
    ///     - details: Some details about the task.
    ///
    /// - Throws: This method can throw when the item failed to get saved.
    public func createItem(title: String, details: String?) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            guard let entity = NSEntityDescription.entity(forEntityName: Constant.todoItemEntityName, in: context) else {
                fatalError("CoreData entity not found")
            }

            let creatingEntity = NSManagedObject(entity: entity, insertInto: context)
            let createdDate = Date.now.timeIntervalSince1970

            creatingEntity.setValue(UUID(), forKey: "identifier")
            creatingEntity.setValue(title, forKey: "title")
            creatingEntity.setValue(details, forKey: "details")
            creatingEntity.setValue(createdDate, forKey: "createdDate")
            creatingEntity.setValue(CoreTodoItemStatus.todo.rawValue, forKey: "status")

            do {
                try context.save()
            } catch {
                throw TodoServiceError.failedToCreateEntity
            }
        }
    }

    /// Use this method to retrieve stored items.
    ///
    /// Entities are sorted the most recent first and descending.
    ///
    /// - Returns: An array of ``CoreTodoItem``.
    ///
    /// - Throws: Method can throw an error defined in ``TodoServiceError``.
    public func retrieveItems() async throws -> [CoreTodoItem] {
        let context = persistentContainer.newBackgroundContext()

        return try await context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.todoItemEntityName)

            let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]

            do {
                let entities = try context.fetch(fetchRequest)
                return entities.compactMap { CoreTodoItem(managedObject: $0) }
            } catch {
                throw TodoServiceError.failedToFetchEntities
            }
        }
    }

    /// Use this method to update an existing entity.
    ///
    /// - Parameters:
    ///     - updateEntity: Some object conforming to ``CoreUpdateEntity`` protocol.
    ///
    /// - Throws: Method can throw a ``TodoServiceError``.
    func updateEntity(updateEntity: some CoreUpdateEntity) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.todoItemEntityName)
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", updateEntity.identifier as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)

                guard !results.isEmpty else {
                    throw TodoServiceError.itemNotFound
                }

                if let updatingEntity = results.first {

                    updatingEntity.setValue(updateEntity.title, forKey: "title")
                    updatingEntity.setValue(updateEntity.details, forKey: "details")
                    updatingEntity.setValue(updateEntity.coreStatus.rawValue, forKey: "status")

                    try context.save()
                }
            } catch let error as TodoServiceError {
                throw error
            } catch {
                throw TodoServiceError.failedToUpdateItem
            }
        }
    }

    /// Use this method to delete entities.
    ///
    /// - Parameters
    ///     - Identifier: A unique UUID identifying an entity.
    ///
    /// - Throws: This method can throw a ``TodoServiceError``.
    public func deleteEntity(withIdentifier identifier: UUID) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.todoItemEntityName)
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)

                guard !results.isEmpty else {
                    throw TodoServiceError.itemNotFound
                }

                for item in results {
                    context.delete(item)
                    try context.save()
                }
            } catch let error as TodoServiceError {
                throw error
            } catch {
                throw TodoServiceError.failedToDeleteAnItem
            }
        }
    }
}
