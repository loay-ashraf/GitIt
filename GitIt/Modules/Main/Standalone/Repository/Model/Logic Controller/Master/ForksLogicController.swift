//
//  ForksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class ForksLogicController: RepositoryLogicController {
    
    // MARK: - Properties
    
    var repositoryFullName: String
    var numberOfForks: Int
    
    // MARK: - Initialization
    
    init(repositoryFullName: String, numberOfForks: Int) {
        self.repositoryFullName = repositoryFullName
        self.numberOfForks = numberOfForks
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler  = handler
        GitHubClient.fetchRepositoryForks(fullName: repositoryFullName, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberOfForks ? false : true
    }
    
}
