//
//  TableViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

typealias WebServicePlainTableViewModel = WebServicePlainViewModel & TableViewModel
typealias WebServiceSearchTableViewModel = WebServiceSearchViewModel & TableViewModel

protocol TableViewModel: AnyObject {
    
    associatedtype TableCellViewModelType: TableCellViewModel
    
    var cellViewModels: List<TableCellViewModelType> { get set }
    var items: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    var currentPage: Int { get }
    var isPaginable: Bool { get }
    
}

extension TableViewModel {
    
    // MARK: - Properties
    
    var items: Array<TableCellViewModelType> { return cellViewModels.items }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    var currentPage: Int { return cellViewModels.currentPage }
    var isPaginable: Bool { return cellViewModels.isPaginable }
    
}
