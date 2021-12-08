//
//  ErrorResponse.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/10/2021.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
