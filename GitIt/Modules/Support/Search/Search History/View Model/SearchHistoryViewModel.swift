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
    typealias ObjectCellViewModelType = UserCollectionCellViewModel
    typealias ModelType = UserModel
    
    var logicController = UserSearchHistoryLogicController()
    var objectCellViewModels = Observable<Array<UserCollectionCellViewModel>>()
    var queryCellViewModels = Observable<Array<QueryCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] objectArray in
            if let objectArray = objectArray {
                self?.objectCellViewModelArray = objectArray.map { return UserCollectionCellViewModel(from: $0) }
            }
        }
        logicController.bindQuery { [weak self] queryArray in
            if let queryArray = queryArray {
                self?.queryCellViewModelArray = queryArray.map { return QueryCellViewModel(from: $0) }
            }
        }
    }
    
}

final class RepositorySearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = RepositorySearchHistoryLogicController
    typealias ObjectCellViewModelType = RepositoryCollectionCellViewModel
    typealias ModelType = RepositoryModel
    
    var logicController = RepositorySearchHistoryLogicController()
    var objectCellViewModels = Observable<Array<RepositoryCollectionCellViewModel>>()
    var queryCellViewModels = Observable<Array<QueryCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] objectArray in
            if let objectArray = objectArray {
                self?.objectCellViewModelArray = objectArray.map { return RepositoryCollectionCellViewModel(from: $0) }
            }
        }
        logicController.bindQuery { [weak self] queryArray in
            if let queryArray = queryArray {
                self?.queryCellViewModelArray = queryArray.map { return QueryCellViewModel(from: $0) }
            }
        }
    }
    
}

final class OrganizationSearchHistoryViewModel: SearchHistoryViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = OrganizationSearchHistoryLogicController
    typealias ObjectCellViewModelType = OrganizationCollectionCellViewModel
    typealias ModelType = OrganizationModel
    
    var logicController = OrganizationSearchHistoryLogicController()
    var objectCellViewModels = Observable<Array<OrganizationCollectionCellViewModel>>()
    var queryCellViewModels = Observable<Array<QueryCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] objectArray in
            if let objectArray = objectArray {
                self?.objectCellViewModelArray = objectArray.map { return OrganizationCollectionCellViewModel(from: $0) }
            }
        }
        logicController.bindQuery { [weak self] queryArray in
            if let queryArray = queryArray {
                self?.queryCellViewModelArray = queryArray.map { return QueryCellViewModel(from: $0) }
            }
        }
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
