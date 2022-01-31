//
//  FollowersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class FollowersLogicController: UserLogicController {
    
    var userLogin: String
    var numberofFollowers: Int
    
    init(userLogin: String, numberofFollowers: Int) {
        self.userLogin = userLogin
        self.numberofFollowers = numberofFollowers
        super.init()
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUserFollowers(userLogin: userLogin, page: model.currentPage, completion: processResult(result:))
    }
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberofFollowers ? false : true
    }
    
}
