import XCTest
@testable import NodeTree

final class NodeTreeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NodeTree().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
