import XCTest
@testable import Todoliti

final class HomeScreenViewModelTests: XCTestCase {

    @MainActor
    func testCanNotCreateTaskWhenTitleIsEmpty() async {
        let sut = HomeScreenViewModel(manager: MockManager())

        sut.createItem(title: "")
        XCTAssertTrue(sut.hasError)

        sut.createItem(title: "test")
        XCTAssertFalse(sut.hasError)
    }

}

private class MockManager: TodoManagerRepresentable {
    func deleteTask(model: Todoliti.TodoItem) async throws {
        // ..
    }
    
    func createTask(title: String) async throws {
        // ..
    }

    func loadTasks() async throws -> [TodoItem] {
        []
    }

    func updateTask(model: TodoItem) async throws {
        // ..
    }
}
