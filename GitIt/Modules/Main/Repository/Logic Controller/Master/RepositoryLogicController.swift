//
//  RepositoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

class RepositoryLogicController {
    
    // MARK: - Properties
    
    var model = List<RepositoryModel>()
    var handler: LoadingHandler?

    // MARK: - Initialization
    
    init() {
        model.isPaginable = true
    }
    
    // MARK: - Loading Methods

    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchRepositories(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    // MARK: - Result Processing Methods
    
    func processResult(result: Result<[RepositoryModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }

    func updateModelParameters(newItemsCount: Int = 0) {
        if model.currentPage == NetworkingConstants.maxPageCount {
            model.isPaginable = false
            return
        } else {
            model.currentPage += 1
        }
    }

}
