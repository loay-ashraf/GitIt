//
//  UserLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/11/2021.
//

import Foundation

class UserLogicController: WebServicePlainLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = UserModel
    
    var webServiceClient = GitHubClient()
    var model = List<UserModel>()
    var handler: NetworkLoadingHandler?
    var maxItemCount: Int?
    var maxPageCount: Int
    
    // MARK: - Initialization
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() {
        webServiceClient.fetchUsers(page: model.currentPage, completionHandler: processFetchResult(result:))
    }
    
}
