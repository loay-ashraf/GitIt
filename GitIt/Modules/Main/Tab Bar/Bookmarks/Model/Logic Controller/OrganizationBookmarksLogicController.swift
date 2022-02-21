//
//  OrganizationBookmarksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class OrganizationBookmarksLogicController: BookmarksLogicController {
   
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    
    var dataPersistenceManager = BookmarksManager.standard
    var model = Array<OrganizationModel>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeBookmarksContext = .organizations
        synchronize()
    }
    
    // MARK: - Model Synchronize Method
    
    func synchronize() {
        if let bookmarksArray = dataPersistenceManager.getOrganizations() {
            model = bookmarksArray.map { return OrganizationModel(from: $0) }
        }
    }
    
}
