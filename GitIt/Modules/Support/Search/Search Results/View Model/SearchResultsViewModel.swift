//
//  SearchResultsViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

final class UserSearchResultsViewModel: SearchResultsViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = UserTableCellViewModel
    typealias LogicControllerType = UserSearchResultsLogicController
    
    var logicController = LogicControllerType()
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
}

final class RepositorySearchResultsViewModel: SearchResultsViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = RepositoryTableCellViewModel
    typealias LogicControllerType = RepositorySearchResultsLogicController
    
    var logicController = LogicControllerType()
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
}

final class OrganizationSearchResultsViewModel: SearchResultsViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    typealias LogicControllerType = OrganizationSearchResultsLogicController
    
    var logicController = LogicControllerType()
    var cellViewModels = List<TableCellViewModelType>()
    var handler: NetworkLoadingHandler?
    
}
