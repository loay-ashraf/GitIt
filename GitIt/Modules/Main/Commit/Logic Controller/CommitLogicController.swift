//
//  CommitLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

class CommitLogicController {
    
    // MARK: - Properties
    
    var model = List<CommitModel>()
    private var repositoryFullName: String
    private var handler: LoadingHandler?

    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        self.repositoryFullName = repositoryFullName
    }
    
    // MARK: - Loading Methods

    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchRepositoryCommits(fullName: repositoryFullName, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    // MARK: - Result Processing Methods
    
    private func processResult(result: Result<[CommitModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        model.isPaginable = newItemsCount == 0 ? false : true
        if model.currentPage == 100 {
            model.isPaginable = false
        } else {
            model.currentPage += 1
        }
    }

}
