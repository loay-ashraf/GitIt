//
//  SearchHistoryTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

struct SearchHistory<T: Model>: Codable {
    
    var objects: Array<T>
    var queries: Array<String>
    
    mutating func clear() {
        objects.removeAll()
        queries.removeAll()
    }
    
    init() {
        objects = Array<T>()
        queries = Array<String>()
    }
    
}
