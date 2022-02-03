//
//  UserViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class UserViewModel: DynamicTableViewModel<UserCellViewModel> {
    
    var logicController: UserLogicController
    
    init(context: UserContext) {
        logicController = context.logicController
    }
    
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
    
    private func synchronizeModel() {
        let modelItems = logicController.model.items
        cellViewModels.items = modelItems.map { return UserCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class UserCellViewModel {
    
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    
    init(from userModel: UserModel) {
        avatarURL = userModel.avatarURL
        htmlURL = userModel.htmlURL
        login = userModel.login
    }
    
}

class DynamicTableViewModel<T> {
    
    var cellViewModels = List<T>()
    var items: [T] { return cellViewModels.items }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    var currentPage: Int { return cellViewModels.currentPage }
    var isPaginable: Bool { return cellViewModels.isPaginable }
    
    func load(then handler: @escaping LoadingHandler) { }
    func refresh(then handler: @escaping LoadingHandler) { }
    
}
