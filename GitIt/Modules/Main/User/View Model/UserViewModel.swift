//
//  UserViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class UserViewModel: TableViewModel<UserCellViewModel> {
    
    // MARK: - Properties
    
    var logicController: UserLogicController
    
    // MARK: - Initialization
    
    init(context: UserContext) {
        logicController = context.logicController
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronizeModel()
                handler(nil)
            }
        }
    }
    
    override func refresh(then handler: @escaping LoadingHandler) {
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
        cellViewModels.items = modelItems.map { return UserCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class UserCellViewModel: CellViewModel {
    
    // MARK: - Properties
    
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    
    // MARK: - Initialization
    
    init(from userModel: UserModel) {
        avatarURL = userModel.avatarURL
        htmlURL = userModel.htmlURL
        login = userModel.login
    }
    
}
