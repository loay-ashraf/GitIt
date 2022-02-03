//
//  CommitViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class CommitViewModel: DynamicTableViewModel<CommitCellViewModel> {
    
    var logicController: CommitLogicController
    
    init(repositoryFullName: String) {
        logicController = CommitLogicController(repositoryFullName: repositoryFullName)
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
        cellViewModels.items = modelItems.map { return CommitCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class CommitCellViewModel {
    
    var author: OwnerModel?
    var htmlURL: URL
    var message: String
    
    init(from commitModel: CommitModel) {
        author = commitModel.author
        htmlURL = commitModel.htmlURL
        message = commitModel.message
    }
    
}
