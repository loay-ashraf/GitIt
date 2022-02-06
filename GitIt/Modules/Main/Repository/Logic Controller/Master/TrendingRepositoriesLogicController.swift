//
//  TrendingRepositoriesLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

class TrendingRepositoriesLogicController: RepositoryLogicController {

    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchTrendingRepositories(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods

    override func updateModelParameters(newItemsCount: Int = 0) {
        if model.currentPage == NetworkingConstants.maxPageCount {
            model.isPaginable = false
        } else {
            model.currentPage += 1
            model.isPaginable = true
        }
    }
    
}
