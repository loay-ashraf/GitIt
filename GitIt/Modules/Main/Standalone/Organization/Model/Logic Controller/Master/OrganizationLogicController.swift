//
//  OrganizationLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

class OrganizationLogicController: WebServicePlainLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = OrganizationModel
    
    var webServiceClient = GitHubClient()
    var model = List<OrganizationModel>()
    var handler: NetworkLoadingHandler?
    var maxItemCount: Int?
    var maxPageCount: Int
    
    // MARK: - Initialization
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        self.maxItemCount = maxItemCount
        self.maxPageCount = maxPageCount
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<Array<OrganizationModel>,NetworkError> {
        await webServiceClient.fetchOrganizations(page: model.currentPage)
    }
    
}
