//
//  FollowingLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

final class FollowingLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var userLogin = String()
    
    // MARK: - Initialization
    
    init(userLogin: String, numberOfFollowing: Int) {
        self.userLogin = userLogin
        super.init(maxItemCount: numberOfFollowing)
    }

    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        super.init(maxItemCount: maxItemCount, maxPageCount: maxPageCount)
    }
    
    // MARK: - Fetch Data Method
    
    override func fetchData() async -> Result<Array<UserModel>,NetworkError> {
        await webServiceClient.fetchUserFollowing(userLogin: userLogin, page: modelList.currentPage)
    }
    
}
