//
//  DataPersistenceLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

protocol DataPersistenceLogicController: AnyObject {
    
    associatedtype DataPersistenceManagerType: DataPersistenceManager
    associatedtype ModelType: Model
    
    var dataPersistenceManager: DataPersistenceManagerType { get }
    var model: Observable<Array<ModelType>> { get set }
    var modelArray: Array<ModelType> { get set }
    
    init()
    
    func add(model: ModelType)
    func delete(model: ModelType)
    func clear()
    
    func bind(_ listener: @escaping (Array<ModelType>?) -> Void)
    func bindToPersistedData()
    
}

extension DataPersistenceLogicController {
    
    // MARK: - Properties
    
    var modelArray: Array<ModelType> {
        get { return model.value ?? Array<ModelType>() }
        set { model.value = newValue }
    }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (Array<ModelType>?) -> Void) {
        model.bind(listener)
    }
    
}
