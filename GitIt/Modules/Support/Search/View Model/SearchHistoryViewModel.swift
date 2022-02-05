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
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    typealias ModelType = UserModel
    
    var logicController = LogicControllerType()
    var objectCellViewModels = Array<CollectionCellViewModelType>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
}

final class RepositorySearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = RepositorySearchHistoryLogicController
    typealias CollectionCellViewModelType = RepositoryCollectionCellViewModel
    typealias ModelType = RepositoryModel
    
    var logicController = LogicControllerType()
    var objectCellViewModels = Array<CollectionCellViewModelType>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
}

final class OrganizationSearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = OrganizationSearchHistoryLogicController
    typealias CollectionCellViewModelType = OrganizationCollectionCellViewModel
    typealias ModelType = OrganizationModel
    
    var logicController = LogicControllerType()
    var objectCellViewModels = Array<CollectionCellViewModelType>()
    var queryCellViewModels = Array<QueryCellViewModel>()
    
}

final class QueryCellViewModel: TableCellViewModel {

    // MARK: - Properties
    
    typealias ModelType = String
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    
    var query: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        query = model
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        query = ""
    }
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType()
    }

}
