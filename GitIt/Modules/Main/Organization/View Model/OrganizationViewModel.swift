//
//  OrganizationViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class OrganizationViewModel: DynamicTableViewModel<OrganizationCellViewModel> {
    
    var logicController: OrganizationLogicController
    
    init(context: OrganizationContext) {
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
        cellViewModels.items = modelItems.map { return OrganizationCellViewModel(from: $0) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}

class OrganizationCellViewModel {
    
    var avatarURL: URL
    var htmlURL: URL
    var login: String
    
    init(from organizationModel: OrganizationModel) {
        avatarURL = organizationModel.avatarURL
        htmlURL = organizationModel.htmlURL
        login = organizationModel.login
    }
    
}
