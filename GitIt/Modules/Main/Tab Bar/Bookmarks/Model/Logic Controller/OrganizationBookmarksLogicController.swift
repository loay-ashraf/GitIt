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
    var model = Observable<Array<OrganizationModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToPersistedData()
    }
    
    // MARK: - Bind to Persisted Data Method

    func bindToPersistedData() {
        dataPersistenceManager.bindOrganizations { [weak self] organizationBookmarks in
            if let organizationBookmarks = organizationBookmarks {
                self?.modelArray = organizationBookmarks.map { return OrganizationModel(from: $0) }
            }
        }
    }
    
}
