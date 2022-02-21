//
//  DataPersistenceViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

protocol DataPersistenceViewModel: AnyObject {
    
    associatedtype LogicControllerType: DataPersistenceLogicController
    associatedtype CellViewModelType: CellViewModel
    associatedtype ModelType: Model
    
    var logicController: LogicControllerType { get }
    var cellViewModels: Array<CellViewModelType> { get set }
    
    init()
    
    func add(cellViewModel: CellViewModelType)
    func delete(cellViewModel: CellViewModelType)
    func clear()
    func synchronize()
    
}
