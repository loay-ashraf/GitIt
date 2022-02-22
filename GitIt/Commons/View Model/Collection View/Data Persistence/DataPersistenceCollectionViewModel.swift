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
    
    var cellViewModels: Array<CollectionCellViewModelType> { get set }
    var items: Array<CollectionCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func add(cellViewModel: CollectionCellViewModelType)
    func delete(cellViewModel: CollectionCellViewModelType)
    func clear()
    
}

extension DataPersistenceCollectionViewModel {
    
    // MARK: - Properties
    
    var items: Array<CollectionCellViewModelType> { return cellViewModels }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    
}
