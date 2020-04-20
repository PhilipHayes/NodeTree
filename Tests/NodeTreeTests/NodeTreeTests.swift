import XCTest
import Foundation
@testable import NodeTree
struct Day : Codable {
	var index:Int?
	var weather:Int?
}
final class NodeTreeTests: XCTestCase {
	func testAddNext() {
		let node = Node(Day(index:0))
		let cursor = NodeCursor(node)
		
		_ = cursor.add(next: Day(index: 1))
		XCTAssert(cursor.getNexts()?.count == 1, "Insert failed")
		XCTAssert(cursor.move(next: 0).getPrevs()?.count == 1, "Bi-directional link failed")
	}
    func testCheckPrev() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		
		let node = Node(Day(index:0))
		let cursor = NodeCursor(node)
		
		let results = cursor.add(next: Day(index: 1))
			.add(next: Day(index: 1, weather: 1))
			.add(next: Day(index: 1, weather: 2))
			.add(next: Day(index: 1, weather: 3))
				.move(next: 1)
				.add(next: Day(index: 2))
				.add(next: Day(index: 2))
					.move(next: 0)
					.checkPrev([{
						print($0.data?.index)
						return $0.data?.index == 0
						
						}])
		
		cursor.root().log()
		//No prior node has an index of 0
		XCTAssert(results == [true], "False negative.")
				
		
		
    }
	
    static var allTests = [
        ("testCheckPrev", testCheckPrev),
    ]
}
