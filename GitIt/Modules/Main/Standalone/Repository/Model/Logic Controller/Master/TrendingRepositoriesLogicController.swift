//
//  TrendingRepositoriesLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

final class TrendingRepositoriesLogicController: RepositoryLogicController {
    
    // MARK: - Fetch Data Method
    
    override func fetchData() async -> Result<Array<RepositoryModel>,NetworkError> {
        await webServiceClient.fetchTrendingRepositories(page: modelList.currentPage)
    }
    
}
