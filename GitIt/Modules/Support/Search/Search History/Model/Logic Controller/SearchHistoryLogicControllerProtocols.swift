//
//  SearchHistoryLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryLogicController: DataPersistenceLogicController where DataPersistenceManagerType == SearchHistoryManager {
    
    var queryModel: Observable<Array<String>> { get set }
    var queryModelArray: Array<String> { get set }
    
    func add(query: String)
    func delete(query: String)
    func bindQuery(_ listener: @escaping (Array<String>?) -> Void)
    
}

extension SearchHistoryLogicController {
    
    // MARK: - Properties
    
    var queryModelArray: Array<String> {
        get { return queryModel.value ?? Array<String>() }
        set { queryModel.value = newValue }
    }
    
    // MARK: - Model Manipulation Methods
    
    func add(model: ModelType) {
        dataPersistenceManager.add(model: model)
    }
    
    func add(query: String) {
        dataPersistenceManager.add(keyword: query, for: ModelType.self)
    }
    
    func delete(model: ModelType) {
        dataPersistenceManager.delete(model: model)
    }
    
    func delete(query: String) {
        dataPersistenceManager.delete(keyword: query, for: ModelType.self)
    }
    
    func clear() {
        dataPersistenceManager.clearActive()
    }
    
    // MARK: - Bind Query Method
    
    func bindQuery(_ listener: @escaping (Array<String>?) -> Void) {
        queryModel.bind(listener)
    }
    
}
