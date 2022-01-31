//
//  StarredLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class StarredLogicController: RepositoryLogicController {
    
    var userLogin: String
    
    init(userLogin: String) {
        self.userLogin = userLogin
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserStarred(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = newItemsCount == 0 ? false : true
    }
    
}
