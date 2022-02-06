//
//  SearchHistoryTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

struct SearchHistory<T: Model>: Codable {
    
    var models: [T]
    var keywords: [String]
    
    mutating func clear() {
        models.removeAll()
        keywords.removeAll()
    }
    
    init() {
        models = []
        keywords = []
    }
    
}
