//
//  OrganizationOwnedLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

final class OrganizationOwnedLogicController: RepositoryLogicController {
    
    // MARK: - Properties
    
    var organizationLogin = String()
    
    // MARK: - Initialization
    
    init(organizationLogin: String, numberOfRepositories: Int) {
        self.organizationLogin = organizationLogin
        super.init(maxItemCount: numberOfRepositories)
    }

    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        super.init(maxItemCount: maxItemCount, maxPageCount: maxPageCount)
    }
    
    // MARK: - Fetch Data Method
    
    override func fetchData() async -> Result<Array<RepositoryModel>,NetworkError> {
        await webServiceClient.fetchOrganizationRepositories(organizationLogin: organizationLogin, page: modelList.currentPage)
    }
    
}
