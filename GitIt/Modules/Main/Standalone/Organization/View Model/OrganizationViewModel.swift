//
//  OrganizationViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class OrganizationViewModel: WebServicePlainTableViewModel {
   
    // MARK: - Properties
    
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    
    var logicController: OrganizationLogicController
    var cellViewModels = Observable<List<OrganizationTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init(context: OrganizationContext) {
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
                self?.cellViewModelList.items = modelItems.map { return OrganizationTableCellViewModel(from: $0) }
                self?.cellViewModelList.currentPage = modelList.currentPage
                self?.cellViewModelList.isPaginable = modelList.isPaginable
            }
        }
    }
    
}

final class OrganizationCollectionCellViewModel: CollectionCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    
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
        bindToBookmarks()
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        model = tableCellViewModel.model
        avatarURL = tableCellViewModel.avatarURL
        htmlURL = tableCellViewModel.htmlURL
        login = tableCellViewModel.login
        isBookmarked = tableCellViewModel.isBookmarked
        bindToBookmarks()
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
    
    // MARK: - Bind to Bookmarks Method
    
    func bindToBookmarks() {
        BookmarksManager.standard.bindOrganizations { [weak self] organizationBookmarks in
            DispatchQueue.main.async {
                if let organizationBookmarks = organizationBookmarks {
                    if organizationBookmarks.contains(where: { return $0.login == self?.login }) {
                        self?.isBookmarked = true
                    } else {
                        self?.isBookmarked = false
                    }
                }
            }
        }
    }
    
}

final class OrganizationTableCellViewModel: TableCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    typealias CollectionCellViewModelType = OrganizationCollectionCellViewModel
    
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
        bindToBookmarks()
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = collectionCellViewModel.model
        avatarURL = collectionCellViewModel.avatarURL
        htmlURL = collectionCellViewModel.htmlURL
        login = collectionCellViewModel.login
        isBookmarked = collectionCellViewModel.isBookmarked
        bindToBookmarks()
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
    
    // MARK: - Bind to Bookmarks Method
    
    func bindToBookmarks() {
        BookmarksManager.standard.bindOrganizations { [weak self] organizationBookmarks in
            DispatchQueue.main.async {
                if let organizationBookmarks = organizationBookmarks {
                    if organizationBookmarks.contains(where: { return $0.login == self?.login }) {
                        self?.isBookmarked = true
                    } else {
                        self?.isBookmarked = false
                    }
                }
            }
        }
    }
    
}
