//
//  TrendingRepositoriesLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

final class TrendingRepositoriesLogicController: RepositoryLogicController {
    
    // MARK: - Fetch Data Method
    
    override func fetchData() {
        webServiceClient.fetchTrendingRepositories(page: model.currentPage, completionHandler: processFetchResult(result:))
    }
    
}
