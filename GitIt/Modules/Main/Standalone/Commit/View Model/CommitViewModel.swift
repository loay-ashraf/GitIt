//
//  CommitViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class CommitViewModel: TableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = CommitCellViewModel
    
    var logicController: CommitLogicController
    var cellViewModels = List<TableCellViewModelType>()
    
    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        logicController = CommitLogicController(repositoryFullName: repositoryFullName)
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronizeModel()
                handler(nil)
            }
        }
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
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
        cellViewModels.items = modelItems.map { return TableCellViewModelType(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

final class CommitCellViewModel: TableCellViewModel {
   
    // MARK: - Properties
    
    typealias ModelType = CommitModel
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    
    var model: ModelType
    var author: OwnerModel?
    var htmlURL: URL
    var message: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        author = model.author
        htmlURL = model.htmlURL
        message = model.message
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = ModelType()
        author = OwnerModel()
        htmlURL = URL(string: "www.github.com")!
        message = ""
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType()
    }
    
}
