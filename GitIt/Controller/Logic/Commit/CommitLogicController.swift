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

    init(parameters: String) {
        self.parameters = parameters
    }

    func load(then handler: @escaping ErrorHandler) {
        NetworkClient.standard.getRepositoryCommits(fullName: parameters, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters(newItemsCount: response.count)
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    func refresh(then handler: @escaping ErrorHandler) {
        model.reset()
        load(then: handler)
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        model.isPaginable = newItemsCount == 0 ? false : true
    }

}
