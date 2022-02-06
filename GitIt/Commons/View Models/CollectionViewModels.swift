//
//  CollectionViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

protocol CollectionViewModel: AnyObject {
    
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    
    var cellViewModels: List<CollectionCellViewModelType> { get set }
    var items: Array<CollectionCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    var currentPage: Int { get }
    var isPaginable: Bool { get }
    
    func load(then handler: @escaping LoadingHandler)
    func refresh(then handler: @escaping LoadingHandler)
    
}

extension CollectionViewModel {
    
    // MARK: - Properties
    
    var items: [CollectionCellViewModelType] { return cellViewModels.items }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    var currentPage: Int { return cellViewModels.currentPage }
    var isPaginable: Bool { return cellViewModels.isPaginable }
    
}

protocol CollectionCellViewModel: AnyObject {
    
    associatedtype ModelType
    associatedtype TableCellViewModelType: TableCellViewModel
    
    init()
    init(from model: ModelType)
    init(from tableCellViewModel: TableCellViewModelType)
    
    func tableCellViewModel() -> TableCellViewModelType
    
}

extension CollectionCellViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
}
