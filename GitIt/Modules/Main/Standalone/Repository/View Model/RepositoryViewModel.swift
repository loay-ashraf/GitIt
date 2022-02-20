//
//  RepositoryViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class RepositoryViewModel: WebServicePlainTableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = RepositoryTableCellViewModel
    
    var logicController: RepositoryLogicController
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Initialization
    
    init(context: RepositoryContext) {
        logicController = context.logicController
    }
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        items[row].toggleBookmark()
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
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
    
    var model: ModelType
    var owner: OwnerModel
    var htmlURL: URL
    var name: String
    var isBookmarked: Bool
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
        isBookmarked = BookmarksManager.standard.check(model: model) ?? false
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        model = tableCellViewModel.model
        owner = tableCellViewModel.owner
        htmlURL = tableCellViewModel.htmlURL
        name = tableCellViewModel.name
        isBookmarked = tableCellViewModel.isBookmarked
    }
    
    // MARK: - View Model Adapter Methods
    
    func tableCellViewModel() -> TableCellViewModelType {
        return TableCellViewModelType(from: self)
    }
    
    // MARK: - View Actions
    
    func toggleBookmark() {
        try? isBookmarked ? BookmarksManager.standard.delete(model: model) : BookmarksManager.standard.add(model: model)
        isBookmarked = !isBookmarked
    }
    
}

final class RepositoryTableCellViewModel: TableCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    typealias CollectionCellViewModelType = RepositoryCollectionCellViewModel
    
    var model: ModelType
    var owner: OwnerModel
    var htmlURL: URL
    var name: String
    var description: String?
    var stargazers: Int
    var language: String?
    var isBookmarked: Bool
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
        description = model.description
        stargazers = model.stars
        language = model.language
        isBookmarked = BookmarksManager.standard.check(model: model) ?? false
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = collectionCellViewModel.model
        owner = collectionCellViewModel.owner
        htmlURL = collectionCellViewModel.htmlURL
        name = collectionCellViewModel.name
        description = nil
        stargazers = 0
        language = nil
        isBookmarked = collectionCellViewModel.isBookmarked
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType(from: self)
    }
    
    // MARK: - View Actions
    
    func toggleBookmark() {
        try? isBookmarked ? BookmarksManager.standard.delete(model: model) : BookmarksManager.standard.add(model: model)
        isBookmarked = !isBookmarked
    }
    
}
