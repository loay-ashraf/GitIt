//
//  UserSearchResponse.swift
//  GitIt
//
//  Created by Loay Ashraf on 26/10/2021.
//

import Foundation

struct BatchResponse<Response: Decodable>: Decodable {
    
    let count: Int
    let incompleteResults: Bool
    let items: [Response]
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
