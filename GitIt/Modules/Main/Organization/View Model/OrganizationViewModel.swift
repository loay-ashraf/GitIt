//
//  OrganizationViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class OrganizationViewModel: TableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    
    var logicController: OrganizationLogicController
    var cellViewModels = List<TableCellViewModelType>()
    
    // MARK: - Initialization
    
    init(context: OrganizationContext) {
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

final class OrganizationCollectionCellViewModel: CollectionCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        avatarURL = tableCellViewModel.avatarURL
        htmlURL = tableCellViewModel.htmlURL
        login = tableCellViewModel.login
    }
    
    // MARK: - View Model Adapter Methods
    
    func tableCellViewModel() -> TableCellViewModelType {
        return TableCellViewModelType(from: self)
    }
    
}

final class OrganizationTableCellViewModel: TableCellViewModel {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    typealias CollectionCellViewModelType = OrganizationCollectionCellViewModel
    
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        login = model.login
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        avatarURL = collectionCellViewModel.avatarURL
        htmlURL = collectionCellViewModel.htmlURL
        login = collectionCellViewModel.login
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType(from: self)
    }
    
}
