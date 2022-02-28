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
    
    var objectCellViewModels: Observable<Array<ObjectCellViewModelType>> { get set }
    var objectCellViewModelArray: Array<ObjectCellViewModelType> { get set }
    var queryCellViewModels: Observable<Array<QueryCellViewModel>> { get set }
    var queryCellViewModelArray: Array<QueryCellViewModel> { get set }
    
    func toggleBookmark(atItem item: Int)
    func reloadObject(atItem item: Int) -> ObjectCellViewModelType
    func deleteObject(atItem item: Int)
    func reloadQuery(atRow row: Int) -> String
    func deleteQuery(atRow row: Int)
    
    func add(cellViewModel: ObjectCellViewModelType)
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(cellViewModel: ObjectCellViewModelType)
    func delete(queryCellViewModel: QueryCellViewModel)
    
    func bindObject(_ listener: @escaping (Array<ObjectCellViewModelType>?) -> Void)
    func bindQuery(_ listener: @escaping (Array<QueryCellViewModel>?) -> Void)
    
}

extension SearchHistoryViewModel {
    
    // MARK: - Properties
    
    var objectCellViewModelArray: Array<ObjectCellViewModelType> {
        get { return objectCellViewModels.value ?? Array<ObjectCellViewModelType>() }
        set { objectCellViewModels.value = newValue }
    }
    
    var queryCellViewModelArray: Array<QueryCellViewModel> {
        get { return queryCellViewModels.value ?? Array<QueryCellViewModel>() }
        set { queryCellViewModels.value = newValue }
    }

    // MARK: - View Actions
    
    func toggleBookmark(atItem item: Int) {
        objectCellViewModelArray[item].toggleBookmark()
    }
    
    func reloadObject(atItem item: Int) -> ObjectCellViewModelType {
        let objectCellViewModelItem = objectCellViewModelArray[item]
        add(cellViewModel: objectCellViewModelItem)
        return objectCellViewModelItem
    }
    
    func deleteObject(atItem item: Int) {
        let objectCellViewModelItem = objectCellViewModelArray[item]
        delete(cellViewModel: objectCellViewModelItem)
    }
    
    func reloadQuery(atRow row: Int) -> String {
        let queryCellViewModelItem = queryCellViewModelArray[row]
        add(queryCellViewModel: queryCellViewModelItem)
        return queryCellViewModelItem.query
    }
    
    func deleteQuery(atRow row: Int) {
        let queryCellViewModelItem = queryCellViewModelArray[row]
        delete(queryCellViewModel: queryCellViewModelItem)
    }
    
    // MARK: - View Model Manipulationn Methods
    
    func add(cellViewModel: ObjectCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.add(model: model as! LogicControllerType.ModelType)
    }
    
    func add(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.add(query: query)
    }
    
    func delete(cellViewModel: ObjectCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.CollectionCellViewModelType)
        logicController.delete(model: model as! LogicControllerType.ModelType)
    }
    
    func delete(queryCellViewModel: QueryCellViewModel) {
        let query = queryCellViewModel.query
        logicController.delete(query: query)
    }
    
    func clear() {
        logicController.clear()
    }
    
    // MARK: - Bind Methods
    
    func bindObject(_ listener: @escaping (Array<ObjectCellViewModelType>?) -> Void) {
        objectCellViewModels.bind(listener)
    }
    
    func bindQuery(_ listener: @escaping (Array<QueryCellViewModel>?) -> Void) {
        queryCellViewModels.bind(listener)
    }
    
}
