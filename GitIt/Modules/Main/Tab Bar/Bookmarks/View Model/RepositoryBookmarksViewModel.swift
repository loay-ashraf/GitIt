//
//  RepositoryBookmarksViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class RepositoryBookmarksViewModel: BookmarksViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = RepositoryBookmarksLogicController
    typealias CellViewModelType = RepositoryTableCellViewModel
    typealias ModelType = RepositoryModel
    
    var logicController = RepositoryBookmarksLogicController()
    var cellViewModels = Array<RepositoryTableCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}
