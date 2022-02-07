//
//  MembersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class MembersLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var organizationLogin: String
    
    // MARK: - Initialization
    
    init(organizationLogin: String) {
        self.organizationLogin = organizationLogin
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchOrganizationMemebers(organizationLogin: organizationLogin, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = newItemsCount == 0 ? false : true
    }
    
}
