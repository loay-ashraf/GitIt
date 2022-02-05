//
//  SearchTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

enum SearchContext {
    
    case general
    case users
    case repositories
    case organizations
    
    var barPlaceholder: String {
        switch self {
        case .general: return Constants.View.SearchBar.general
        case .users: return Constants.View.SearchBar.users
        case .repositories: return Constants.View.SearchBar.repositories
        case .organizations: return Constants.View.SearchBar.organizations
        }
    }
    
    init?<Type: Model>(from modelType: Type.Type) {
        switch Type.self {
        case is UserModel.Type: self = .users
        case is RepositoryModel.Type: self = .repositories
        case is OrganizationModel.Type: self = .organizations
        default: self = .general
        }
    }
    
}

enum SearchUIState {
    
    case idle
    case searching
    
}

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
