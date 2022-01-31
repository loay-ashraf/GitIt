//
//  OrganizationOwnedLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class OrganizationOwnedLogicController: RepositoryLogicController {
    
    var organizationLogin: String
    var numberOfRepositories: Int
    
    init(organizationLogin: String, numberOfRepositories: Int) {
        self.organizationLogin = organizationLogin
        self.numberOfRepositories = numberOfRepositories
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler  = handler
        GitHubClient.fetchOrganizationRepositories(organizationLogin: organizationLogin, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberOfRepositories ? false : true
    }
    
}
