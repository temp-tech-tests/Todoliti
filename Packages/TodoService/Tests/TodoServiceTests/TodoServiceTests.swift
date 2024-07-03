import XCTest
import CoreData
@testable import TodoService

final class TodoServiceTests: XCTestCase {

    private var nonPersistantStoreDescription: NSPersistentStoreDescription {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        return description
    }

    func testItemsCreation() async {
        let sut = TodoService(storeDescription: nonPersistantStoreDescription)

        do {
            try await sut.createItem(title: "Test", details: "Test details")
            try await sut.createItem(title: "Test-1", details: nil)
        } catch {
            XCTFail("Service should manage to create items")
        }
    }

    func testItemsCreateAndRetrieveEntities() async throws {
        let sut = TodoService(storeDescription: nonPersistantStoreDescription)

        try await sut.createItem(title: "Test", details: "Test details")
        try await sut.createItem(title: "Test-1", details: nil)

        let entities = try await sut.retrieveItems()

        XCTAssertEqual(entities.count, 2)
    }
}
