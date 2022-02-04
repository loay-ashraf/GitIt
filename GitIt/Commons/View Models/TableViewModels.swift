//
//  TableViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

class TableViewModel<T> {
    
    var cellViewModels = List<T>()
    var items: [T] { return cellViewModels.items }
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    var currentPage: Int { return cellViewModels.currentPage }
    var isPaginable: Bool { return cellViewModels.isPaginable }
    
    func load(then handler: @escaping LoadingHandler) { }
    func refresh(then handler: @escaping LoadingHandler) { }
    
}

protocol CellViewModel { }
