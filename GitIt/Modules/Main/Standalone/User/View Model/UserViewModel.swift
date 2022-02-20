//
//  UserViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class UserViewModel: WebServicePlainTableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = UserTableCellViewModel
    
    var logicController: UserLogicController
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Initialization
    
    init(context: UserContext) {
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

final class UserCollectionCellViewModel: CollectionCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = UserModel
    typealias TableCellViewModelType = UserTableCellViewModel
    
    var model: ModelType
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    var isBookmarked: Bool
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
        isBookmarked = BookmarksManager.standard.check(model: model) ?? false
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        model = tableCellViewModel.model
        avatarURL = tableCellViewModel.avatarURL
        htmlURL = tableCellViewModel.htmlURL
        login = tableCellViewModel.login
        isBookmarked = tableCellViewModel.isBookmarked
    }
    
    // MARK: - View Model Adapter Methods
    
    func tableCellViewModel() -> UserTableCellViewModel {
        return TableCellViewModelType(from: self)
    }
    
    // MARK: - View Actions
    
    func toggleBookmark() {
        try? isBookmarked ? BookmarksManager.standard.delete(model: model) : BookmarksManager.standard.add(model: model)
        isBookmarked = !isBookmarked
    }
    
}

final class UserTableCellViewModel: TableCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = UserModel
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    
    var model: ModelType
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    var isBookmarked: Bool
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
        isBookmarked = BookmarksManager.standard.check(model: model) ?? false
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = collectionCellViewModel.model
        avatarURL = collectionCellViewModel.avatarURL
        htmlURL = collectionCellViewModel.htmlURL
        login = collectionCellViewModel.login
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
