//
//  SearchHistoryDelegates.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

protocol SearchHistoryLogicController: AnyObject {
    
    associatedtype ModelType: Model
    
    var model: SearchHistory<ModelType> { get set }
    var modelManager: SearchHistoryManager { get set }
    
    init()
    
    func load(handler: @escaping LoadingHandler)
    func add(model: ModelType)
    func add(keyword: String)
    func delete(model: ModelType)
    func delete(keyword: String)
    func clear()
    func synchronize()
    
}

extension SearchHistoryLogicController {
    
    // MARK: - Loading Methods
    
    func load(handler: @escaping LoadingHandler) {
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

protocol SearchHistoryViewModel: AnyObject {
    
    associatedtype LogicControllerType: SearchHistoryLogicController
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    associatedtype ModelType: Model
    
    var logicController: LogicControllerType { get set }
    var objectCellViewModels: Array<CollectionCellViewModelType> { get set }
    var queryCellViewModels: Array<QueryCellViewModel> { get set }
    
    init()
    
    func load(handler: @escaping LoadingHandler)
    func add(objectCellViewModel: CollectionCellViewModelType)
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(objectCellViewModel: CollectionCellViewModelType)
    func delete(queryCellViewModel: QueryCellViewModel)
    func clear()
    func synchronize()
    
}

extension SearchHistoryViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Loading Methods
    
    func load(handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            self?.synchronize()
            handler(error)
        }
    }
    
    // MARK: - View Model Manipulationn Methods
    
    func add(objectCellViewModel: CollectionCellViewModelType) {
        let model = ModelType(from: objectCellViewModel as! ModelType.T)
        logicController.add(model: model as! LogicControllerType.ModelType)
        synchronize()
    }
    
    func add(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.add(keyword: query)
        synchronize()
    }
    
    func delete(objectCellViewModel: CollectionCellViewModelType) {
        let model = ModelType(from: objectCellViewModel as! ModelType.T)
        logicController.delete(model: model as! LogicControllerType.ModelType)
        synchronize()
    }
    
    func delete(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.delete(keyword: query)
        synchronize()
    }
    
    func clear() {
        logicController.clear()
        synchronize()
    }
    
    // MARK: - View Model Synchronization Methods
    
    func synchronize() {
        let modelItems = logicController.model.models
        let queryItems = logicController.model.keywords
        objectCellViewModels = modelItems.map { return CollectionCellViewModelType(from: $0 as! CollectionCellViewModelType.ModelType) }
        queryCellViewModels = queryItems.map { return QueryCellViewModel(from: $0) }
    }
    
}

protocol SearchHistoryDelegate: AnyObject {
    
    func historySearch(with query: String)
    func dismissHistoryKeyboard()
    
}

protocol SearchHistoryCollectionDelegate: AnyObject {
    
    var objectCellViewModels: Array<AnyObject> { get }
    
    func add(objectCellViewModel: AnyObject)
    func delete(objectCellViewModel: AnyObject)
    func updateCollection()
    func didUpdateCollection()
    func dismissHistoryKeyboard()
    
}

protocol SearchHistoryTableDelegate: AnyObject {
    
    var queryCellViewModels: Array<QueryCellViewModel> { get }
    
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(queryCellViewModel: QueryCellViewModel)
    func updateTable()
    func didUpdateTable()
    
}
