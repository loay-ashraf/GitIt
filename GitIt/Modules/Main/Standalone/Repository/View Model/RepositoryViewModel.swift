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
    var cellViewModels = Observable<List<RepositoryTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init(context: RepositoryContext) {
        logicController = context.logicController
        bindToModel()
    }
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        items[row].toggleBookmark()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelList in
            if let modelList = modelList {
                let modelItems = modelList.items
                self?.cellViewModelList.items = modelItems.map { return RepositoryTableCellViewModel(from: $0) }
                self?.cellViewModelList.currentPage = modelList.currentPage
                self?.cellViewModelList.isPaginable = modelList.isPaginable
            }
        }
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
    var isBookmarked: Bool = false
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
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
        DispatchQueue.main.async {
            try? self.isBookmarked ? BookmarksManager.standard.delete(model: self.model) : BookmarksManager.standard.add(model: self.model)
            self.isBookmarked = !self.isBookmarked
        }
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
    var isBookmarked: Bool = false
    
    // MARK: - Initialization
    
    init(from model: ModelType)  {
        self.model = model
        owner = model.owner
        htmlURL = model.htmlURL
        name = model.name
        description = model.description
        stargazers = model.stars
        language = model.language
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
        DispatchQueue.main.async {
            try? self.isBookmarked ? BookmarksManager.standard.delete(model: self.model) : BookmarksManager.standard.add(model: self.model)
            self.isBookmarked = !self.isBookmarked
        }
    }
    
}
