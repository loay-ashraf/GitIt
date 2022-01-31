//
//  RepositoryTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

enum RepositoryContext {
    
    case main
    case user(userLogin: String,numberOfRepositories: Int)
    case organization(organizationLogin: String,numberOfRepositories: Int)
    case forks(repositoryFullName: String,numberOfForks: Int)
    case starred(userLogin: String)
    
    var logicController: RepositoryLogicController {
        switch self {
        case .main: return RepositoryLogicController()
        case .user(let userLogin, let numberOfRepositories): return UserOwnedLogicController(userLogin: userLogin, numberOfRepositories: numberOfRepositories)
        case .organization(let organizationLogin, let numberOfRepositories): return OrganizationOwnedLogicController(organizationLogin: organizationLogin, numberOfRepositories: numberOfRepositories)
        case .forks(let repositoryFullName, let numberOfForks): return ForksLogicController(repositoryFullName: repositoryFullName, numberOfForks: numberOfForks)
        case .starred(let userLogin): return StarredLogicController(userLogin: userLogin)
        }
    }
    
    var title: String {
        switch self {
        case .forks: return Constants.View.Title.repositories.forks
        case .starred: return Constants.View.Title.repositories.starred
        default: return Constants.View.Title.repositories.main
        }
    }
    
}
