//
//  Model.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

protocol Model: Codable, Equatable {
    
    var id: Int { get }
    var htmlURL: URL { get }
    var isComplete: Bool { get set }
    
}
