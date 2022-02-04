//
//  FollowersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class FollowersLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var userLogin: String
    var numberofFollowers: Int
    
    // MARK: - Initialization
    
    init(userLogin: String, numberofFollowers: Int) {
        self.userLogin = userLogin
        self.numberofFollowers = numberofFollowers
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserFollowers(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberofFollowers ? false : true
    }
    
}
