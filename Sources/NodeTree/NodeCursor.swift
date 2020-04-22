//
//  File.swift
//  
//
//  Created by Philip Hayes on 4/19/20.
//

import Foundation
@dynamicMemberLookup
public class NodeCursor<T> {
	///The current location in a given tree tree
	var cursor:Node<T>?

	public subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value? {

		get {
			guard let cursor = cursor else {return nil}

			return cursor.data[keyPath: keyPath]
			
		}
    }
	
	public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value?>) -> Value? {
		get {
			guard let cursor = cursor else {return nil}

			return cursor.data[keyPath: keyPath]
			
		}
		set {
			guard let cursor = cursor else {return}

			cursor.data[keyPath: keyPath] = newValue
			
		}
    }
	
	public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> Value? {

		get {
			guard let cursor = cursor else {return nil}

			return cursor.data[keyPath: keyPath]
			
		}
		set {
			guard let cursor = cursor else {return}
			guard let v = newValue else {return}
			cursor.data[keyPath: keyPath] = v
			
		}
    }
	public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value?>) -> Value? {
		get {
			guard let cursor = cursor else {return nil}

			return cursor.data[keyPath: keyPath]
			
		}
		set {
			guard let cursor = cursor else {return}

			cursor.data[keyPath: keyPath] = newValue
			
		}
    }
	
	public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value>) -> Value? {

		get {
			guard let cursor = cursor else {return nil}

			return cursor.data[keyPath: keyPath]
			
		}
		set {
			guard let cursor = cursor else {return}
			guard let v = newValue else {return}
			cursor.data[keyPath: keyPath] = v
			
		}
    }
	public init(_ node:Node<T>? = nil) {
		cursor = node
	}
	public func getNexts() -> Array<Node<T>>? {
		return cursor?.next
	}
	public func getPrevs() -> Array<Node<T>>? {
		return cursor?.previous
	}
	public func get(next:Int) -> Node<T>? {
		return cursor?.getNext(index: next)
	}
	public func get(prev:Int? = nil) -> Node<T>? {
		return cursor?.getPrevious(index: prev)
	}
	public func add(next:T) -> Self {
		cursor?.addNext(node: Node(next))
		return self
	}
	public func add(prev:T) -> Self {
		cursor?.addPrev(node: Node(prev))
		return self
	}
	public func set(prev:T) -> Self {
		cursor?.setPrev(node: Node(prev))
		return self
	}
	public func add(next:Node<T>) -> Self {
		cursor?.addNext(node: next)
		return self
	}
	public func add(prev:Node<T>) -> Self {
		cursor?.addPrev(node: prev)
		return self
	}
	public func set(prev:Node<T>) -> Self {
		cursor?.setPrev(node: prev)
		return self
	}
	public func remove(prev:Int? = nil) {
		cursor?.removePrev(index: prev)
	}
	public func move(next:Int) -> Self {
		guard let node = get(next: next) else {
			return self
		}
		_ = set(node)
		return self
	}
	public func back(prev:Int? = nil) -> Self {
		guard let node = get(prev: prev) else {
			return self
		}
		_ = set(node)
		return self
	}
	public func root() -> Self {
		var cur = cursor
		var ids = Set<String>()
		ids.insert(cursor?.id ?? "")
		while let node = cur?.previous?.first {
			guard ids.insert(node.id).inserted == true else {
				break
			}
			cur = node
		}
		_ = set(cur)
		return self
	}
	
	public func set(_ node:Node<T>?) -> Self {
		cursor = node
		return self
	}
	public func log() -> Self {
		var ids:Set<String> = []
		cursor?.log(&ids)
		return self
	}
	public func check(_ conditions:[Predicate<T>]) -> [Bool]? {
		
		return cursor?.check(conditions: conditions)
	}
	public func checkPrev(_ conditions:[Predicate<T>]) -> [Bool]? {
		
		return cursor?.checkPrev(conditions: conditions)
	}
	
}
