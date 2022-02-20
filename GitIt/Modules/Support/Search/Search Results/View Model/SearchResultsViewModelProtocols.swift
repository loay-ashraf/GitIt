//
//  SearchResultsViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsViewModel: WebServiceSearchTableViewModel {
    
    func toggleBookmark(atRow row: Int)
    
}

extension SearchResultsViewModel {
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        items[row].toggleBookmark()
    }
    
    // MARK: - Synchronization Method
    
    func synchronize() {
        let modelItems = logicController.model.items
        cellViewModels.items = modelItems.map { return TableCellViewModelType(from: $0 as! TableCellViewModelType.ModelType) }
        cellViewModels.currentPage = logicController.model.currentPage
        cellViewModels.isPaginable = logicController.model.isPaginable
    }
    
}
