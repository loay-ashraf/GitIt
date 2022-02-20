//
//  CommitLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

final class CommitLogicController: WebServicePlainLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = CommitModel
    
    var webServiceClient = GitHubClient()
    var model = List<CommitModel>()
    var repositoryFullName = String()
    var handler: NetworkLoadingHandler?
    var maxItemCount: Int?
    var maxPageCount: Int

    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        self.repositoryFullName = repositoryFullName
        self.maxPageCount = NetworkingConstants.maxPageCount
        self.model.isPaginable = true
    }
    
    init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() {
        webServiceClient.fetchRepositoryCommits(fullName: repositoryFullName, page: model.currentPage, completionHandler: processFetchResult(result:))
    }

}
