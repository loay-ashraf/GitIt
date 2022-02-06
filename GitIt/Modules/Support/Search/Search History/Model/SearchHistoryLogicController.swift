//
//  SearchHistoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

final class UserSearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = UserModel
    
    var model = SearchHistory<ModelType>()
    var modelManager = SearchHistoryManager.standard
    
    // MARK: - Initialization
    
    init() {
        modelManager.activeSearchContext = .users
    }
    
    // MARK: - Model Synchronization Methods

    func synchronize() {
        model = modelManager.userHistory
    }
    
}

final class RepositorySearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    
    var model = SearchHistory<ModelType>()
    var modelManager = SearchHistoryManager.standard
    
    // MARK: - Initialization
    
    init() {
        modelManager.activeSearchContext = .repositories
    }
    
    // MARK: - Model Synchronization Methods

    func synchronize() {
        model = modelManager.repositoryHistory
    }
    
}

final class OrganizationSearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = OrganizationModel
    
    var model = SearchHistory<ModelType>()
    var modelManager = SearchHistoryManager.standard
    
    // MARK: - Initialization
    
    init() {
        modelManager.activeSearchContext = .organizations
    }
    
    // MARK: - Model Synchronization Methods

    func synchronize() {
        model = modelManager.organizationHistory
    }
    
}
