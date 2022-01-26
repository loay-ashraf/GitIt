//
//  TrendingLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 26/01/2022.
//

import Foundation

class TrendingLogicController {
    
    var model = List<RepositoryModel>()
    private var handler: LoadingHandler?

    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchTrendingRepositories(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func processResult(result: Result<[RepositoryModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        if model.currentPage == NetworkingConstants.maxPageCount {
            model.isPaginable = false
        } else {
            model.currentPage += 1
            model.isPaginable = true
        }
    }
    
}
