import Foundation
public class Node<T:Codable> : Identifiable, Codable {
	public var id:String = UUID().uuidString
	var next:Array<Node<T>>?
	var previous:Array<Node<T>>?
	
	var data:T?
	public init(_ value:T? = nil) {
		self.data = value
	}
	
	public func log() {
		var ids = Set<String>()

		print("Value: \(data)")
		if let nexts = next {
			print("nexts [\(nexts.map {$0.id})])")
			nexts.forEach {
				guard ids.insert($0.id).inserted else {
					return
				}
				$0.log()
				
			}

		}
	}
	public func getNext(index:Int) -> Node<T>? {
		guard let next = next else {return nil}
		guard index >= 0 && index < next.count else {return nil}
		return next[index]
	}
	public func addNext(node:Node<T>) {
		if next == nil {
			next = []
		}
		next?.append(node)
		node.previous = [self]
	}
	public func getPrevious(index:Int? = nil) -> Node<T>? {
		guard let prev = previous else {return nil}
		guard let index = index else {return prev.first}
		guard index >= 0 && index < prev.count else {return nil}
		return prev[index]
	}
	public func setPrev(node:Node<T>) {
		previous = [node]
		if node.next == nil {
			node.next = [self]
		} else {
			node.next?.append(self)

		}
	}
	public func addPrev(node:Node<T>) {
		if previous == nil {
			previous = [node]
		} else {
			previous?.append(node)

		}
		if node.next == nil {
			node.next = [self]
		} else {
			node.next?.append(self)

		}
		
	}
	public func removePrev(index:Int? = nil) {
		guard let index = index else {
			previous?.forEach {$0.next = $0.next?.filter{$0.id != self.id}}
			previous = nil

			return
		}
		previous?[index].next = previous?[index].next?.filter{$0.id != self.id}

	}
	
	public func checkPrev(conditions:[(Node<T>)->(Bool)]) -> [Bool] {
		var node:Node<T>? = self
		var results = [Bool](repeating: false, count: conditions.count)
		while node != nil {
			
			node?.check(conditions: conditions, results: &results)
			node = node?.getPrevious()
		}
		return results
	}
	
	public func check(conditions:[(Node<T>)->(Bool)], results:inout [Bool]) -> [Bool] {
			
		for p in conditions.enumerated() {
			if p.element(self) {
				results[p.offset] = true
			}
			
		}
		return results
	}
	
	public func check(conditions:[(Node<T>)->(Bool)]) -> [Bool] {
		var results = [Bool](repeating: false, count: conditions.count)
			
		for p in conditions.enumerated() {
			if p.element(self) {
				results[p.offset] = true
			}
			
		}
		return results
	}

}
