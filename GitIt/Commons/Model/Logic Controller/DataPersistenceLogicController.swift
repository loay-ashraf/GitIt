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
    var model: Array<ModelType> { get set }
    
    init()
    
    func add(model: ModelType)
    func delete(model: ModelType)
    func clear()
    func synchronize()
    
}
