import Foundation
public typealias Predicate<T> = (Node<T>)->(Bool)
public struct NodeSettings {
	static public var allowsMultiplePreviousLinks = false

}
@dynamicMemberLookup
open class Node<T> : Identifiable {
	public var id:String = UUID().uuidString
	var next:Array<Node<T>>?
	var previous:Array<Node<T>>?
	
	public var data:T
	public init(_ value:T) {
		self.data = value
	}
	
	public subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value? {
        get { data[keyPath: keyPath] }
    }
	public subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value {
        get { data[keyPath: keyPath] }
    }
	public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value?>) -> Value? {
        get { data[keyPath: keyPath] }
        set { data[keyPath: keyPath] = newValue }
    }
	public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> Value {
        get { data[keyPath: keyPath] }
        set { data[keyPath: keyPath] = newValue }
    }
	public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value?>) -> Value? {
        get { data[keyPath: keyPath] }
        set { data[keyPath: keyPath] = newValue }
    }
	public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value>) -> Value {
        get { data[keyPath: keyPath] }
        set { data[keyPath: keyPath] = newValue }
    }
	public func log(_ ids:inout Set<String>) {
		var ids = ids
		print("Value: \(data)")
		if let nexts = next {
			print("nexts [\(nexts.map {$0.id})])")
			for next in nexts {
				guard ids.insert(next.id).inserted else {
					return
				}
				next.log(&ids)
				
			}

		}
	}
	public func getNext(index:Int) -> Node<T>? {
		guard let next = next else {return nil}
		guard index >= 0 && index < next.count else {return nil}
		return next[index]
	}
	public func addNext(node:Node<T>, additive:Bool = NodeSettings.allowsMultiplePreviousLinks) {
		guard next?.contains(where: {$0.id == node.id}) ?? false == false else {return}
		next = (next ?? []) + [node]

		if additive {
			node.addPrev(node: self)
		} else {
			node.setPrev(node: self)
		}
		
	}
	public func getPrevious(index:Int? = nil) -> Node<T>? {
		guard let prev = previous else {return nil}
		guard let index = index else {return prev.first}
		guard index >= 0 && index < prev.count else {return nil}
		return prev[index]
	}
	public func setPrev(node:Node<T>) {
		guard previous?.contains(where:{$0.id == node.id}) ?? false == false else {return}
		previous = [node]
		node.addNext(node: self)
	}
	public func addPrev(node:Node<T>) {
		guard previous?.contains(where:{$0.id == node.id}) ?? false == false else {return}

		previous = (previous ?? []) + [node]
		node.addNext(node: self)
		
	}
	public func removePrev(index:Int? = nil) {
		guard let index = index else {
			previous?.forEach {$0.next = $0.next?.filter{$0.id != self.id}}
			previous = nil

			return
		}
		previous?[index].next = previous?[index].next?.filter{$0.id != self.id}

	}
	
	public func checkPrev(conditions:[Predicate<T>]) -> [Bool] {
		var ids = Set<String>()
		var node:Node<T>? = self
		var results = [Bool](repeating: false, count: conditions.count)
		while node != nil {
			guard ids.insert(node?.id ?? "").inserted == true else {break}
			node?.check(conditions: conditions, results: &results)
			node = node?.getPrevious()
			
		}
		return results
	}
	
	public func check(conditions:[Predicate<T>], results:inout [Bool]) -> [Bool] {
		
		for p in conditions.enumerated() {
			if p.element(self) {
				results[p.offset] = true
			}
			
		}
		return results
	}
	
	public func check(conditions:[Predicate<T>]) -> [Bool] {
		var results = [Bool](repeating: false, count: conditions.count)
			
		for p in conditions.enumerated() {
			if p.element(self) {
				results[p.offset] = true
			}
			
		}
		return results
	}

}
