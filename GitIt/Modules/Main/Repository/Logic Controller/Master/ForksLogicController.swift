//
//  ForksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class ForksLogicController: RepositoryLogicController {
    
    var repositoryFullName: String
    var numberOfForks: Int
    
    init(repositoryFullName: String, numberOfForks: Int) {
        self.repositoryFullName = repositoryFullName
        self.numberOfForks = numberOfForks
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler  = handler
        GitHubClient.fetchRepositoryForks(fullName: repositoryFullName, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberOfForks ? false : true
    }
    
}
