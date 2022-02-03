//
//  RepositoryViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class RepositoryViewModel: DynamicTableViewModel<RepositoryCellViewModel> {
    
    var logicController: RepositoryLogicController
    
    init(context: RepositoryContext) {
        logicController = context.logicController
    }
    
    override func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronizeModel()
                handler(nil)
            }
        }
    }
    
    override func refresh(then handler: @escaping LoadingHandler) {
        logicController.refresh { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronizeModel()
                handler(nil)
            }
        }
    }
    
    private func synchronizeModel() {
        let modelItems = logicController.model.items
        cellViewModels.items = modelItems.map { return RepositoryCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class RepositoryCellViewModel {
    
    var owner: OwnerModel
    var htmlURL: URL
    var name: String
    var description: String?
    var stargazers: Int
    var language: String?
    
    init(from repositoryModel: RepositoryModel) {
        owner = repositoryModel.owner
        htmlURL = repositoryModel.htmlURL
        name = repositoryModel.name
        description = repositoryModel.description
        stargazers = repositoryModel.stars
        language = repositoryModel.language
    }
    
}
