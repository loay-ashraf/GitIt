//
//  WebServiceCollectionViewModels.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

typealias WebServicePlainCollectionViewModel = WebServicePlainViewModel & WebServiceCollectionViewModel
typealias WebServiceSearchCollectionViewModel = WebServiceSearchViewModel & WebServiceCollectionViewModel

protocol WebServiceCollectionViewModel: AnyObject {
    
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    
    var cellViewModels: Observable<List<CollectionCellViewModelType>> { get set }
    var cellViewModelList: List<CollectionCellViewModelType> { get set }
    var items: Array<CollectionCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    var currentPage: Int { get }
    var isPaginable: Bool { get }
    
    func bind(_ listener: @escaping (List<CollectionCellViewModelType>?) -> Void)
    
}

extension WebServiceCollectionViewModel {
    
    // MARK: - Properties
    
    var cellViewModelList: List<CollectionCellViewModelType> {
        get { return cellViewModels.value ?? List<CollectionCellViewModelType>() }
        set { cellViewModels.value = newValue }
    }
    
    var items: [CollectionCellViewModelType] { return cellViewModelList.items }
    var count: Int { return cellViewModelList.count }
    var isEmpty: Bool { return cellViewModelList.isEmpty }
    var currentPage: Int { return cellViewModelList.currentPage }
    var isPaginable: Bool { return cellViewModelList.isPaginable }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (List<CollectionCellViewModelType>?) -> Void) {
        cellViewModels.bind(listener)
    }
    
}
