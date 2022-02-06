//
//  SearchHistoryViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

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
