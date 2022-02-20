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
    
    func reloadObject(atItem item: Int) -> CollectionCellViewModelType
    func toggleBookmark(atItem item: Int)
    func deleteObject(atItem item: Int)
    func reloadQuery(atRow row: Int) -> String
    func deleteQuery(atRow row: Int)
    func load(handler: @escaping NetworkLoadingHandler)
    func add(objectCellViewModel: CollectionCellViewModelType)
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(objectCellViewModel: CollectionCellViewModelType)
    func delete(queryCellViewModel: QueryCellViewModel)
    func clear()
    func synchronizeObjects()
    func synchronizeQueries()
    
}

extension SearchHistoryViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - View Actions
    
    func reloadObject(atItem item: Int) -> CollectionCellViewModelType {
        let objectCellViewModelItem = objectCellViewModels[item]
        add(objectCellViewModel: objectCellViewModelItem)
        return objectCellViewModelItem
    }
    
    func toggleBookmark(atItem item: Int) {
        objectCellViewModels[item].toggleBookmark()
    }
    
    func deleteObject(atItem item: Int) {
        let objectCellViewModelItem = objectCellViewModels[item]
        delete(objectCellViewModel: objectCellViewModelItem)
    }
    
    func reloadQuery(atRow row: Int) -> String {
        let queryCellViewModelItem = queryCellViewModels[row]
        add(queryCellViewModel: queryCellViewModelItem)
        return queryCellViewModelItem.query
    }
    
    func deleteQuery(atRow row: Int) {
        let queryCellViewModelItem = queryCellViewModels[row]
        delete(queryCellViewModel: queryCellViewModelItem)
    }
    
    // MARK: - Loading Methods
    
    func load(handler: @escaping NetworkLoadingHandler) {
        logicController.load { [weak self] error in
            self?.synchronizeObjects()
            self?.synchronizeQueries()
            handler(error)
        }
    }
    
    // MARK: - View Model Manipulationn Methods
    
    func add(objectCellViewModel: CollectionCellViewModelType) {
        let model = ModelType(from: objectCellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.add(model: model as! LogicControllerType.ModelType)
        synchronizeObjects()
    }
    
    func add(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.add(keyword: query)
        synchronizeQueries()
    }
    
    func delete(objectCellViewModel: CollectionCellViewModelType) {
        let model = ModelType(from: objectCellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.delete(model: model as! LogicControllerType.ModelType)
        synchronizeObjects()
    }
    
    func delete(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.delete(keyword: query)
        synchronizeQueries()
    }
    
    func clear() {
        logicController.clear()
        synchronizeObjects()
        synchronizeQueries()
    }
    
    // MARK: - View Model Synchronization Methods
    
    func synchronizeObjects() {
        let objectItems = logicController.model.objects
        objectCellViewModels = objectItems.map { return CollectionCellViewModelType(from: $0 as! CollectionCellViewModelType.ModelType) }
    }
    
    func synchronizeQueries() {
        let queryItems = logicController.model.queries
        queryCellViewModels = queryItems.map { return QueryCellViewModel(from: $0) }
    }
    
}
