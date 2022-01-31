//
//  UserOwnedLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class UserOwnedLogicController: RepositoryLogicController {
    
    var userLogin: String
    var numberOfRepositories: Int
    
    init(userLogin: String, numberOfRepositories: Int) {
        self.userLogin = userLogin
        self.numberOfRepositories = numberOfRepositories
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler  = handler
        GitHubClient.fetchUserRepositories(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberOfRepositories ? false : true
    }
    
}
