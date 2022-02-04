//
//  ContributorsLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class ContributorsLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var repositoryFullName: String
    
    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        self.repositoryFullName = repositoryFullName
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchRepositoryContributors(fullName: repositoryFullName, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = newItemsCount == 0 ? false : true
    }
    
}
