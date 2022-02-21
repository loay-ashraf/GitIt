//
//  UserSearchHistoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class UserSearchHistoryLogicController: SearchHistoryLogicController {
    
    // MARK: - Properties
    
    typealias ModelType = UserModel
    
    var dataPersistenceManager = SearchHistoryManager.standard
    var model = Array<ModelType>()
    var queryModel = Array<String>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeSearchContext = .users
        synchronize()
    }
    
    // MARK: - Model Synchronization Method

    func synchronize() {
        model = dataPersistenceManager.userHistory.objects
        queryModel = dataPersistenceManager.userHistory.queries
    }
    
}
