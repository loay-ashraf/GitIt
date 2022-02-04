//
//  CommitViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class CommitViewModel: TableViewModel<CommitCellViewModel> {
    
    // MARK: - Properties
    
    var logicController: CommitLogicController
    
    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        logicController = CommitLogicController(repositoryFullName: repositoryFullName)
    }
    
    // MARK: - Loading Methods
    
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
    
    // MARK: - Model Synchronization Methods
    
    private func synchronizeModel() {
        let modelItems = logicController.model.items
        cellViewModels.items = modelItems.map { return CommitCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class CommitCellViewModel: CellViewModel {
    
    // MARK: - Properties
    
    var author: OwnerModel?
    var htmlURL: URL
    var message: String
    
    // MARK: - Loading Methods
    
    init(from commitModel: CommitModel) {
        author = commitModel.author
        htmlURL = commitModel.htmlURL
        message = commitModel.message
    }
    
}
