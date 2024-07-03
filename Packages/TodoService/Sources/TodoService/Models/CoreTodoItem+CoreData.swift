import Foundation
import CoreData

extension CoreTodoItem {
    init?(managedObject: NSManagedObject) {
        guard let identifier = managedObject.value(forKey: ObjectKey.identifier.rawValue) as? UUID,
              let title = managedObject.value(forKey: ObjectKey.title.rawValue) as? String,
              let createdDate = managedObject.value(forKey: ObjectKey.createdDate.rawValue) as? Double else { return nil }

        self.identifier = identifier
        self.title = title
        self.createdDate = Date(timeIntervalSince1970: createdDate)

        if let details = managedObject.value(forKey: ObjectKey.details.rawValue) as? String {
            self.details = details
        } else {
            self.details = nil
        }

    }
}
