//
//  FollowingLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class FollowingLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var userLogin: String
    var numberofFollowing: Int
    
    // MARK: - Initialization
    
    init(userLogin: String, numberofFollowing: Int) {
        self.userLogin = userLogin
        self.numberofFollowing = numberofFollowing
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserFollowing(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberofFollowing ? false : true
    }
    
}
