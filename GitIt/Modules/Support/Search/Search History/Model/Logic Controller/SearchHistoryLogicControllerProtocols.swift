//
//  SearchHistoryLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryLogicController: DataPersistenceLogicController where DataPersistenceManagerType == SearchHistoryManager {
    
    var queryModel: Array<String> { get set }
    
    func add(query: String)
    func delete(query: String)
    
}

extension SearchHistoryLogicController {
    
    // MARK: - Model Manipulation Methods
    
    func add(model: ModelType) {
        dataPersistenceManager.add(model: model)
        synchronize()
    }
    
    func add(query: String) {
        dataPersistenceManager.add(keyword: query, for: ModelType.self)
        synchronize()
    }
    
    func delete(model: ModelType) {
        dataPersistenceManager.delete(model: model)
        synchronize()
    }
    
    func delete(query: String) {
        dataPersistenceManager.delete(keyword: query, for: ModelType.self)
        synchronize()
    }
    
    func clear() {
        dataPersistenceManager.clearActive()
        synchronize()
    }
    
}
