//
//  SearchResultsViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsViewModel: TableViewModel {
    
    associatedtype LogicControllerType: SearchResultsLogicController
    
    var logicController: LogicControllerType { get set }
    
    init()
    
    func reset()
    func setQuery(query: String)
    func synchronize()
    
}

extension SearchResultsViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronize()
                handler(nil)
            }
        }
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        logicController.refresh { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronize()
                handler(nil)
            }
        }
    }
    
    func reset() {
        logicController.reset()
        synchronize()
    }
    
    // MARK: - Query Setting Methods
    
    func setQuery(query: String) {
        logicController.query = query
    }
    
    // MARK: - View Model Synchronization Methods
    
    func synchronize() {
        let modelItems = logicController.model.items
        cellViewModels.items = modelItems.map { return TableCellViewModelType(from: $0 as! TableCellViewModelType.ModelType) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}
