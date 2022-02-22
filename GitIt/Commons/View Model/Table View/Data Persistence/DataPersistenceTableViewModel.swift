//
//  DataPersistenceTableViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import Foundation

protocol DataPersistenceTableViewModel: DataPersistenceViewModel {
    
    associatedtype TableCellViewModelType: TableCellViewModel
    associatedtype ModelType: Model
    
    var cellViewModels: Array<TableCellViewModelType> { get set }
    var items: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func add(cellViewModel: TableCellViewModelType)
    func delete(cellViewModel: TableCellViewModelType)
    func clear()
    
}

extension DataPersistenceTableViewModel {
    
    // MARK: - Properties
    
    var items: Array<TableCellViewModelType> { return cellViewModels }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    
}
