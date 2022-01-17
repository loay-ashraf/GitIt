//
//  CommitLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

class CommitLogicController {
    
    var model = List<CommitModel>()
    private var parameters: String
    private var handler: LoadingHandler?

    init(parameters: String) {
        self.parameters = parameters
    }

    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        NetworkClient.standard.getRepositoryCommits(fullName: parameters, page: model.currentPage, perPage: 10, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func processResult(result: Result<[CommitModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        model.isPaginable = newItemsCount == 0 ? false : true
    }

}