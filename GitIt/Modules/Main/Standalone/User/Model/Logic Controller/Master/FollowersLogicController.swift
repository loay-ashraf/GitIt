//
//  FollowersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

final class FollowersLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var userLogin = String()
    
    // MARK: - Initialization
    
    init(userLogin: String, numberOfFollowers: Int) {
        self.userLogin = userLogin
        super.init(maxItemCount: numberOfFollowers)
    }
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        super.init(maxItemCount: maxItemCount, maxPageCount: maxPageCount)
    }
    
    // MARK: - Fetch Data Method
    
    override func fetchData() {
        webServiceClient.fetchUserFollowers(userLogin: userLogin, page: model.currentPage, completion: processFetchResult(result:))
    }
    
}
