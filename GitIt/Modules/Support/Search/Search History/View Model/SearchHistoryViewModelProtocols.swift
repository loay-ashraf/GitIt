//
//  SearchHistoryViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryViewModel: DataPersistenceViewModel where LogicControllerType: SearchHistoryLogicController {
    
    associatedtype ObjectCellViewModelType: CollectionCellViewModel
    associatedtype ModelType: Model
    
    var objectCellViewModels: Array<ObjectCellViewModelType> { get set }
    var queryCellViewModels: Array<QueryCellViewModel> { get set }
    
    func reloadObject(atItem item: Int) -> ObjectCellViewModelType
    func toggleBookmark(atItem item: Int)
    func deleteObject(atItem item: Int)
    func reloadQuery(atRow row: Int) -> String
    func deleteQuery(atRow row: Int)
    
    func add(cellViewModel: ObjectCellViewModelType)
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(cellViewModel: ObjectCellViewModelType)
    func delete(queryCellViewModel: QueryCellViewModel)
    func synchronizeObjects()
    func synchronizeQueries()
    
}

extension SearchHistoryViewModel {
    
    // MARK: - View Actions
    
    func reloadObject(atItem item: Int) -> ObjectCellViewModelType {
        let objectCellViewModelItem = objectCellViewModels[item]
        add(cellViewModel: objectCellViewModelItem)
        return objectCellViewModelItem
    }
    
    func toggleBookmark(atItem item: Int) {
        objectCellViewModels[item].toggleBookmark()
    }
    
    func deleteObject(atItem item: Int) {
        let objectCellViewModelItem = objectCellViewModels[item]
        delete(cellViewModel: objectCellViewModelItem)
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
    
    // MARK: - View Model Manipulationn Methods
    
    func add(cellViewModel: ObjectCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.add(model: model as! LogicControllerType.ModelType)
        synchronizeObjects()
    }
    
    func add(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.add(query: query)
        synchronizeQueries()
    }
    
    func delete(cellViewModel: ObjectCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.delete(model: model as! LogicControllerType.ModelType)
        synchronizeObjects()
    }
    
    func delete(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.delete(query: query)
        synchronizeQueries()
    }
    
    func clear() {
        logicController.clear()
        synchronize()
    }
    
    // MARK: - View Model Synchronization Methods
    
    func synchronize() {
        synchronizeObjects()
        synchronizeQueries()
    }
    
    func synchronizeObjects() {
        let objectItems = logicController.model
        objectCellViewModels = objectItems.map { return ObjectCellViewModelType(from: $0 as! ObjectCellViewModelType.ModelType) }
    }
    
    func synchronizeQueries() {
        let queryItems = logicController.queryModel
        queryCellViewModels = queryItems.map { return QueryCellViewModel(from: $0) }
    }
    
}
