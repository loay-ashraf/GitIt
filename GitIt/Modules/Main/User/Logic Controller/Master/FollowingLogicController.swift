//
//  FollowingLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class FollowingLogicController: UserLogicController {
    
    var userLogin: String
    var numberofFollowing: Int
    
    init(userLogin: String, numberofFollowing: Int) {
        self.userLogin = userLogin
        self.numberofFollowing = numberofFollowing
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserFollowing(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberofFollowing ? false : true
    }
    
}
