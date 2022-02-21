//
//  SearchHistoryViewControllerExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

extension SearchHistoryViewController {
    
    // MARK: - Search Coordinator Outlet Methods
    
    func addObject<X: CollectionCellViewModel>(with cellViewModel: X) {
        viewModel.add(cellViewModel: cellViewModel as! T.CellViewModelType)
        updateCollectionView()
        layoutView()
    }
    
    func addQuery(with query: String) {
        viewModel.add(queryCellViewModel: QueryCellViewModel(from: query))
        updateTableView()
        layoutView()
    }
    
}
