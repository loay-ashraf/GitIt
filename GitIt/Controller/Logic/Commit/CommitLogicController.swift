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

    typealias ViewStateHandler = (ViewState) -> Void

    init(parameters: String) {
        self.parameters = parameters
    }

    func refresh(then handler: @escaping ViewStateHandler) {
        model.reset()
        load(then: handler)
    }

    func load(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.getRepositoryCommits(fullName: parameters, page: model.currentPage, perPage: 10) { response, error in
            if error != nil {
                handler(.failed(error!))
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters(newItemsCount: response.count)
                handler(.presenting)
            }
        }
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        model.isPaginable = newItemsCount == 0 ? false : true
    }

}