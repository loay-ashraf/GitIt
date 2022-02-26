//
//  UserBookmarksViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class UserBookmarksViewModel: BookmarksViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = UserBookmarksLogicController
    typealias TableCellViewModelType = UserTableCellViewModel
    typealias ModelType = UserModel
    
    var logicController = UserBookmarksLogicController()
    var cellViewModels = Observable<Array<UserTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] userBookmarks in
            if let userBookmarks = userBookmarks {
                self?.cellViewModelArray = userBookmarks.map { return UserTableCellViewModel(from: $0) }
            }
        }
    }
    
}
