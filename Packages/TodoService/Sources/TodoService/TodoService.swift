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
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private let storeDescription: NSPersistentStoreDescription

    /// Main initializer for ``TodoService``
    ///
    /// - Parameters:
    ///     - storeDescription: A custom store description to pass to ``TodoService`` for unit testing for instance.
    public init(storeDescription: NSPersistentStoreDescription = NSPersistentStoreDescription()) {
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

            creatingEntity.setValue(title, forKey: "title")
            creatingEntity.setValue(details, forKey: "details")
            creatingEntity.setValue(createdDate, forKey: "createdDate")

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
}
