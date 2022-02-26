//
//  UserOwnedLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

final class UserOwnedLogicController: RepositoryLogicController {
    
    // MARK: - Properties
    
    var userLogin = String()
    
    // MARK: - Initialization
    
    init(userLogin: String, numberOfRepositories: Int) {
        self.userLogin = userLogin
        super.init(maxItemCount: numberOfRepositories)
    }
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        super.init(maxItemCount: maxItemCount, maxPageCount: maxPageCount)
    }
    
    // MARK: - Fetch Data Method
    
    override func fetchData() async -> Result<Array<RepositoryModel>,NetworkError> {
        await webServiceClient.fetchUserRepositories(userLogin: userLogin, page: modelList.currentPage)
    }
    
}
