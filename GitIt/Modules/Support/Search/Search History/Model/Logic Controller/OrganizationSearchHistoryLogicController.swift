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
    var model = Array<ModelType>()
    var queryModel = Array<String>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeSearchContext = .organizations
        synchronize()
    }
    
    // MARK: - Model Synchronization Method

    func synchronize() {
        model = dataPersistenceManager.organizationHistory.objects
        queryModel = dataPersistenceManager.organizationHistory.queries
    }
    
}
