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
    
    var cellViewModels: Observable<Array<TableCellViewModelType>> { get set }
    var cellViewModelArray: Array<TableCellViewModelType> { get set }
    var items: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func add(cellViewModel: TableCellViewModelType)
    func delete(cellViewModel: TableCellViewModelType)
    func clear()
    
    func bind(_ listener: @escaping (Array<TableCellViewModelType>?) -> Void)
    
}

extension DataPersistenceTableViewModel {
    
    // MARK: - Properties
    
    var cellViewModelArray: Array<TableCellViewModelType> {
        get { return cellViewModels.value ?? Array<TableCellViewModelType>() }
        set { cellViewModels.value = newValue }
    }
    
    var items: Array<TableCellViewModelType> { return cellViewModelArray }
    var count: Int { return cellViewModelArray.count }
    var isEmpty: Bool { return cellViewModelArray.isEmpty }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (Array<TableCellViewModelType>?) -> Void) {
        cellViewModels.bind(listener)
    }
    
}
