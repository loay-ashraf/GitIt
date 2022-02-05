//
//  SearchResultsLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

final class UserSearchResultsLogicController: SearchResultsLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = UserModel
    
    var model = List<ModelType>()
    var query = String()
    var handler: LoadingHandler?
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.searchUsers(keyword: query, page: model.currentPage, completionHandler: processResult(result:))
    }
    
}

final class RepositorySearchResultsLogicController: SearchResultsLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    
    var model = List<ModelType>()
    var query = String()
    var handler: LoadingHandler?
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.searchRepositories(keyword: query, page: model.currentPage, completionHandler: processResult(result:))
    }
    
}

final class OrganizationSearchResultsLogicController: SearchResultsLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    
    var model = List<ModelType>()
    var query = String()
    var handler: LoadingHandler?
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.searchOrganizations(keyword: query, page: model.currentPage, completionHandler: processResult(result:))
    }
    
}
