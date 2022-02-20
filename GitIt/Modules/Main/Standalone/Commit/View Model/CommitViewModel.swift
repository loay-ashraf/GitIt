//
//  CommitViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class CommitViewModel: WebServicePlainTableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = CommitCellViewModel
    
    var logicController: CommitLogicController
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        logicController = CommitLogicController(repositoryFullName: repositoryFullName)
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
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
