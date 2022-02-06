//
//  TableViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

protocol TableViewModel: AnyObject {
    
    associatedtype TableCellViewModelType: TableCellViewModel
    
    var cellViewModels: List<TableCellViewModelType> { get set }
    var items: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    var currentPage: Int { get }
    var isPaginable: Bool { get }
    
    func load(then handler: @escaping LoadingHandler)
    func refresh(then handler: @escaping LoadingHandler)
    
}

extension TableViewModel {
    
    // MARK: - Properties
    
    var items: Array<TableCellViewModelType> { return cellViewModels.items }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    var currentPage: Int { return cellViewModels.currentPage }
    var isPaginable: Bool { return cellViewModels.isPaginable }
    
}

protocol TableCellViewModel: AnyObject {
    
    associatedtype ModelType
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    
    init()
    init(from model: ModelType)
    init(from collectionCellViewModel: CollectionCellViewModelType)
    
    func collectionCellViewModel() -> CollectionCellViewModelType
    
}

extension TableCellViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
}
