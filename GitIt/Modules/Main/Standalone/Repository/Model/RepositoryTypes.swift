//
//  RepositoryTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

enum RepositoryContext: ViewControllerContext {
    
    case main
    case trending
    case user(userLogin: String,numberOfRepositories: Int)
    case organization(organizationLogin: String,numberOfRepositories: Int)
    case forks(repositoryFullName: String,numberOfForks: Int)
    case starred(userLogin: String)
    
    var logicController: RepositoryLogicController {
        switch self {
        case .main: return RepositoryLogicController()
        case .trending: return TrendingRepositoriesLogicController()
        case .user(let userLogin, let numberOfRepositories): return UserOwnedLogicController(userLogin: userLogin, numberOfRepositories: numberOfRepositories)
        case .organization(let organizationLogin, let numberOfRepositories): return OrganizationOwnedLogicController(organizationLogin: organizationLogin, numberOfRepositories: numberOfRepositories)
        case .forks(let repositoryFullName, let numberOfForks): return ForksLogicController(repositoryFullName: repositoryFullName, numberOfForks: numberOfForks)
        case .starred(let userLogin): return StarredLogicController(userLogin: userLogin)
        }
    }
    
    var title: String {
        switch self {
        case .trending: return TitleConstants.repositories.trending
        case .forks: return TitleConstants.repositories.forks
        case .starred: return TitleConstants.repositories.starred
        default: return TitleConstants.repositories.main
        }
    }
    
}
