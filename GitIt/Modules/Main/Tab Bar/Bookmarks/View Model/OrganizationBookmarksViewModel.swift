//
//  OrganizationBookmarksViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class OrganizationBookmarksViewModel: BookmarksViewModel {
    
    // MARK: - Properties
    
    typealias LogicControllerType = OrganizationBookmarksLogicController
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    typealias ModelType = OrganizationModel
    
    var logicController = OrganizationBookmarksLogicController()
    var cellViewModels = Observable<Array<OrganizationTableCellViewModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] organizationBookmarks in
            if let organizationBookmarks = organizationBookmarks {
                self?.cellViewModelArray = organizationBookmarks.map { return OrganizationTableCellViewModel(from: $0) }
            }
        }
    }
    
}
