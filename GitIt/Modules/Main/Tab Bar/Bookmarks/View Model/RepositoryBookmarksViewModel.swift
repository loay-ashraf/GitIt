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
    typealias TableCellViewModelType = RepositoryTableCellViewModel
    typealias ModelType = RepositoryModel
    
    var logicController = RepositoryBookmarksLogicController()
    var cellViewModels = Observable<Array<RepositoryTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] repositoryBookmarks in
            if let repositoryBookmarks = repositoryBookmarks {
                self?.cellViewModelArray = repositoryBookmarks.map { return RepositoryTableCellViewModel(from: $0) }
            }
        }
    }
    
}
