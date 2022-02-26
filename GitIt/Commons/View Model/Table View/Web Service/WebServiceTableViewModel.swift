//
//  WebServiceTableViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

typealias WebServicePlainTableViewModel = WebServicePlainViewModel & WebServiceTableViewModel
typealias WebServiceSearchTableViewModel = WebServiceSearchViewModel & WebServiceTableViewModel

protocol WebServiceTableViewModel: AnyObject {
    
    associatedtype TableCellViewModelType: TableCellViewModel
    
    var cellViewModels: Observable<List<TableCellViewModelType>> { get set }
    var cellViewModelList: List<TableCellViewModelType> { get set }
    var items: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    var currentPage: Int { get }
    var isPaginable: Bool { get }
    
    func bind(_ listener: @escaping (List<TableCellViewModelType>?) -> Void)
    
}

extension WebServiceTableViewModel {
    
    // MARK: - Properties
    
    var cellViewModelList: List<TableCellViewModelType> {
        get { return cellViewModels.value ?? List<TableCellViewModelType>() }
        set { cellViewModels.value = newValue }
    }
    
    var items: Array<TableCellViewModelType> { return cellViewModelList.items }
    var count: Int { return cellViewModelList.count }
    var isEmpty: Bool { return cellViewModelList.isEmpty }
    var currentPage: Int { return cellViewModelList.currentPage }
    var isPaginable: Bool { return cellViewModelList.isPaginable }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (List<TableCellViewModelType>?) -> Void) {
        cellViewModels.bind(listener)
    }
    
}
