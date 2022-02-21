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
    typealias CellViewModelType = UserTableCellViewModel
    typealias ModelType = UserModel
    
    var logicController = UserBookmarksLogicController()
    var cellViewModels = Array<UserTableCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}
