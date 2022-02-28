//
//  BookmarksTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

enum BookmarksContext {
    
    case general
    case users
    case repositories
    case organizations
    
    init?<Type: Model>(from modelType: Type.Type) {
        switch Type.self {
        case is UserModel.Type: self = .users
        case is RepositoryModel.Type: self = .repositories
        case is OrganizationModel.Type: self = .organizations
        default: self = .general
        }
    }
    
}
