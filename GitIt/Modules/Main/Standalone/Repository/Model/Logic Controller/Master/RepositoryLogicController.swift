//
//  RepositoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

class RepositoryLogicController: WebServicePlainLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = RepositoryModel
    
    var webServiceClient = GitHubClient()
    var model = List<RepositoryModel>()
    var handler: NetworkLoadingHandler?
    var maxItemCount: Int?
    var maxPageCount: Int

    // MARK: - Initialization
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }

    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<Array<RepositoryModel>,NetworkError> {
        await webServiceClient.fetchRepositories(page: model.currentPage)
    }

}
