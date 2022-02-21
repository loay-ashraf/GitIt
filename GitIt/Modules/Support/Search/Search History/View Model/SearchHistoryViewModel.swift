//
//  SearchHistoryViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

final class UserSearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = UserSearchHistoryLogicController
    typealias CellViewModelType = UserCollectionCellViewModel
    typealias ModelType = UserModel
    
    var logicController = UserSearchHistoryLogicController()
    var cellViewModels = Array<UserCollectionCellViewModel>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}

final class RepositorySearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = RepositorySearchHistoryLogicController
    typealias CellViewModelType = RepositoryCollectionCellViewModel
    typealias ModelType = RepositoryModel
    
    var logicController = RepositorySearchHistoryLogicController()
    var cellViewModels = Array<RepositoryCollectionCellViewModel>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}

final class OrganizationSearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = OrganizationSearchHistoryLogicController
    typealias CellViewModelType = OrganizationCollectionCellViewModel
    typealias ModelType = OrganizationModel
    
    var logicController = OrganizationSearchHistoryLogicController()
    var cellViewModels = Array<OrganizationCollectionCellViewModel>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}

final class QueryCellViewModel: TableCellViewModel {

    // MARK: - Properties
    
    typealias ModelType = String
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    
    var model = String()
    var query: String {
        get { return model }
        set { model = newValue }
    }
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = ""
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType()
    }

}
