//
//  RepositoryViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class RepositoryViewModel: TableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = RepositoryTableCellViewModel
    
    var logicController: RepositoryLogicController
    var cellViewModels = List<TableCellViewModelType>()
    
    // MARK: - Initialization
    
    init(context: RepositoryContext) {
        logicController = context.logicController
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

final class RepositoryCollectionCellViewModel: CollectionCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    typealias TableCellViewModelType = RepositoryTableCellViewModel
    
    var owner: OwnerModel
    var htmlURL: URL
    var name: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        owner = tableCellViewModel.owner
        htmlURL = tableCellViewModel.htmlURL
        name = tableCellViewModel.name
    }
    
    // MARK: - View Model Adapter Methods
    
    func tableCellViewModel() -> TableCellViewModelType {
        return TableCellViewModelType(from: self)
    }
    
}

final class RepositoryTableCellViewModel: TableCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    typealias CollectionCellViewModelType = RepositoryCollectionCellViewModel
    
    var owner: OwnerModel
    var htmlURL: URL
    var name: String
    var description: String?
    var stargazers: Int
    var language: String?
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
        description = model.description
        stargazers = model.stars
        language = model.language
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        owner = collectionCellViewModel.owner
        htmlURL = collectionCellViewModel.htmlURL
        name = collectionCellViewModel.name
        description = nil
        stargazers = 0
        language = nil
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType(from: self)
    }
    
}
