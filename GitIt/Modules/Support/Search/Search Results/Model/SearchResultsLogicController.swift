//
//  SearchResultsLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

final class UserSearchResultsLogicController: SearchResultsLogicController {

    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = UserModel
    
    var webServiceClient = GitHubClient()
    var model = Observable<List<UserModel>>()
    var query = String()
    var maxItemCount: Int?
    var maxPageCount: Int
    
    // MARK: - Initialization
    
    init() {
        self.maxItemCount = nil
        self.maxPageCount = NetworkingConstants.maxPageCount
    }
    
    init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<BatchResponse<UserModel>, NetworkError> {
        await webServiceClient.searchUsers(query: query, page: modelList.currentPage)
    }
    
}

final class RepositorySearchResultsLogicController: SearchResultsLogicController {

    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = RepositoryModel
    
    var webServiceClient = GitHubClient()
    var model = Observable<List<RepositoryModel>>()
    var query = String()
    var maxItemCount: Int?
    var maxPageCount: Int
    
    // MARK: - Initialization
    
    init() {
        self.maxItemCount = nil
        self.maxPageCount = NetworkingConstants.maxPageCount
    }
    
    init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<BatchResponse<RepositoryModel>, NetworkError> {
        await webServiceClient.searchRepositories(query: query, page: modelList.currentPage)
    }
    
}

final class OrganizationSearchResultsLogicController: SearchResultsLogicController {

    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = OrganizationModel
    
    var webServiceClient = GitHubClient()
    var model = Observable<List<OrganizationModel>>()
    var query = String()
    var maxItemCount: Int?
    var maxPageCount: Int
    
    // MARK: - Initialization
    
    init() {
        self.maxItemCount = nil
        self.maxPageCount = NetworkingConstants.maxPageCount
    }
    
    init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<BatchResponse<OrganizationModel>, NetworkError> {
        await webServiceClient.searchOrganizations(query: query, page: modelList.currentPage)
    }
    
}
