//
//  DataPersistenceCollectionViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import Foundation

protocol DataPersistenceCollectionViewModel: DataPersistenceViewModel {
    
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    associatedtype ModelType: Model
    
    var cellViewModels: Observable<Array<CollectionCellViewModelType>> { get set }
    var cellViewModelArray: Array<CollectionCellViewModelType> { get set }
    var items: Array<CollectionCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func add(cellViewModel: CollectionCellViewModelType)
    func delete(cellViewModel: CollectionCellViewModelType)
    func clear()
    
    func bind(_ listener: @escaping (Array<CollectionCellViewModelType>?) -> Void)
    
}

extension DataPersistenceCollectionViewModel {
    
    // MARK: - Properties
    
    var cellViewModelArray: Array<CollectionCellViewModelType> {
        get { return cellViewModels.value ?? Array<CollectionCellViewModelType>() }
        set { cellViewModels.value = newValue }
    }
    
    var items: Array<CollectionCellViewModelType> { return cellViewModelArray }
    var count: Int { return cellViewModelArray.count }
    var isEmpty: Bool { return cellViewModelArray.isEmpty }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (Array<CollectionCellViewModelType>?) -> Void) {
        cellViewModels.bind(listener)
    }
    
}
