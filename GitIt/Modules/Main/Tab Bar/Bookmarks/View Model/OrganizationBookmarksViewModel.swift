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
    typealias CellViewModelType = OrganizationTableCellViewModel
    typealias ModelType = OrganizationModel
    
    var logicController = OrganizationBookmarksLogicController()
    var cellViewModels = Array<OrganizationTableCellViewModel>()
    
    // MARK: - Initialization
    
    init() {
        synchronize()
    }
    
}
