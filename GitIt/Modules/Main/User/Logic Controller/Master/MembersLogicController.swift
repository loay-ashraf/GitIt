//
//  MembersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class MembersLogicController: UserLogicController {
    
    var organizationLogin: String
    
    init(organizationLogin: String) {
        self.organizationLogin = organizationLogin
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchOrganizationMemebers(organizationLogin: organizationLogin, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = newItemsCount == 0 ? false : true
    }
    
}
