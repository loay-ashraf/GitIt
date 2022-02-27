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
    var cellViewModels = Observable<List<UserTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init(context: UserContext) {
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
                self?.cellViewModelList.items = modelItems.map { return UserTableCellViewModel(from: $0) }
                self?.cellViewModelList.currentPage = modelList.currentPage
                self?.cellViewModelList.isPaginable = modelList.isPaginable
            }
        }
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
    var isBookmarked: Bool = false
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
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
        DispatchQueue.main.async {
            try? self.isBookmarked ? BookmarksManager.standard.delete(model: self.model) : BookmarksManager.standard.add(model: self.model)
            self.isBookmarked = !self.isBookmarked
        }
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
    var isBookmarked: Bool = false
    
    // MARK: - Initialization
    
    init(from model: ModelType)  {
        self.model = model
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
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
        DispatchQueue.main.async {
            try? self.isBookmarked ? BookmarksManager.standard.delete(model: self.model) : BookmarksManager.standard.add(model: self.model)
            self.isBookmarked = !self.isBookmarked
        }
    }
    
}
