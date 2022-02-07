//
//  UserEnrolledLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class UserEnrolledLogicController: OrganizationLogicController {
    
    // MARK: - Properties
    
    var userLogin: String
    
    // MARK: - Initialization
    
    init(userLogin: String) {
        self.userLogin = userLogin
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserOrganizations(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = newItemsCount == 0 ? false : true
    }
    
}
