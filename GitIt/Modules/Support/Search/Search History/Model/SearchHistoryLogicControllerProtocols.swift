//
//  SearchHistoryLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryLogicController: AnyObject {
    
    associatedtype ModelType: Model
    
    var model: SearchHistory<ModelType> { get set }
    var modelManager: SearchHistoryManager { get set }
    
    init()
    
    func load(handler: @escaping NetworkLoadingHandler)
    func add(model: ModelType)
    func add(keyword: String)
    func delete(model: ModelType)
    func delete(keyword: String)
    func clear()
    func synchronize()
    
}

extension SearchHistoryLogicController {
    
    // MARK: - Loading Methods
    
    func load(handler: @escaping NetworkLoadingHandler) {
        synchronize()
        handler(nil)
    }
    
    // MARK: - Model Manipulationn Methods
    
    func add(model: ModelType) {
        modelManager.add(model: model)
        synchronize()
    }
    
    func add(keyword: String) {
        modelManager.add(keyword: keyword, for: ModelType.self)
        synchronize()
    }
    
    func delete(model: ModelType) {
        modelManager.delete(model: model)
        synchronize()
    }
    
    func delete(keyword: String) {
        modelManager.delete(keyword: keyword, for: ModelType.self)
        synchronize()
    }
    
    func clear() {
        modelManager.clear(for: ModelType.self)
        synchronize()
    }
    
}
