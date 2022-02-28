//
//  FoundationTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

struct List<T> {
    
    var items: [T] = []
    var isPaginable: Bool = false
    var currentPage: Int = 1
    
    var count: Int { return items.count }
    var isEmpty: Bool { return items.isEmpty }
    
    init() {}
    
    init(with items: [T]) {
        self.items = items
    }
    
    mutating func reset() {
        items.removeAll()
        isPaginable = false
        currentPage = 1
    }
    
    mutating func reset(isPagiable: Bool) {
        items.removeAll()
        self.isPaginable = isPagiable
        currentPage = 1
    }
    
    mutating func insert(_ newElement: T, at index: Int) {
        items.insert(newElement, at: index)
    }
    
    mutating func insert(contentsOf newElements: [T], at index: Int) {
        items.insert(contentsOf: newElements, at: index)
    }
    
    mutating func append(_ newElement: T) {
        items.append(newElement)
    }
    
    mutating func append(contentsOf newElements: [T]) {
        items.append(contentsOf: newElements)
    }
    
    mutating func append(contentsOf newElements: [T], withSizeLimit sizeLimit: Int?) {
        sizeLimit != nil ? items.append(contentsOf: newElements, withSizeLimit: sizeLimit!) : items.append(contentsOf: newElements)
    }
    
    mutating func remove(at index: Int) {
        items.remove(at: index)
    }
    
    mutating func removeAll(_ item: T) where T: Equatable {
        items.removeAll() { value in return value == item }
    }
    
}

struct Observable<T> {
    
    var value: T? {
        didSet {
            listeners.forEach { $0(value) }
        }
    }
    
    private var listeners = Array<(T?) -> Void>()
    
    init() {
        self.value = nil
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    mutating func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        listeners.append(listener)
    }
    
}
