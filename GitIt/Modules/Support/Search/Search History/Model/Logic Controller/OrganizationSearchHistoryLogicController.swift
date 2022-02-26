//
//  OrganizationSearchHistoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class OrganizationSearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    
    var dataPersistenceManager = SearchHistoryManager.standard
    var model = Observable<Array<OrganizationModel>>()
    var queryModel = Observable<Array<String>>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeSearchContext = .organizations
        bindToPersistedData()
    }
    
    // MARK: - Bind to Persisted Data Method

    func bindToPersistedData() {
        dataPersistenceManager.bindOrganizations { [weak self] organizationHistory in
            if let organizationHistory = organizationHistory {
                self?.modelArray = organizationHistory.objects
                self?.queryModelArray = organizationHistory.queries
            }
        }
    }
    
}
