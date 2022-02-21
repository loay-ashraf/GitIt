//
//  RepositorySearchHistoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class RepositorySearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    
    var dataPersistenceManager = SearchHistoryManager.standard
    var model = Array<ModelType>()
    var queryModel = Array<String>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeSearchContext = .repositories
        synchronize()
    }
    
    // MARK: - Model Synchronization Method

    func synchronize() {
        model = dataPersistenceManager.repositoryHistory.objects
        queryModel = dataPersistenceManager.repositoryHistory.queries
    }
    
}
