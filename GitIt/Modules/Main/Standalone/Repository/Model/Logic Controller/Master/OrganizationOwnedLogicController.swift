//
//  OrganizationOwnedLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class OrganizationOwnedLogicController: RepositoryLogicController {
    
    // MARK: - Properties
    
    var organizationLogin: String
    var numberOfRepositories: Int
    
    // MARK: - Initialization
    
    init(organizationLogin: String, numberOfRepositories: Int) {
        self.organizationLogin = organizationLogin
        self.numberOfRepositories = numberOfRepositories
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler  = handler
        GitHubClient.fetchOrganizationRepositories(organizationLogin: organizationLogin, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberOfRepositories ? false : true
    }
    
}
