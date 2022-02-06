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
        viewModel.add(objectCellViewModel: cellViewModel as! T.CollectionCellViewModelType)
        updateCollectionView()
        layoutView()
    }
    
    func addQuery(with query: String) {
        viewModel.add(queryCellViewModel: QueryCellViewModel(from: query))
        updateTableView()
        layoutView()
    }
    
}

extension SearchHistoryViewController: SearchHistoryCollectionDelegate {
    
    // MARK: - Collection View Controller Delegate Methods
    
    var objectCellViewModels: Array<AnyObject> { return viewModel.objectCellViewModels as Array<AnyObject> }
    
    func add(objectCellViewModel: AnyObject) {
        viewModel.add(objectCellViewModel: objectCellViewModel as! T.CollectionCellViewModelType)
    }
    
    func delete(objectCellViewModel: AnyObject) {
        viewModel.delete(objectCellViewModel: objectCellViewModel as! T.CollectionCellViewModelType)
        synchronizeCollectionView()
    }
    
    func updateCollection() {
        updateCollectionView()
    }
    
    func didUpdateCollection() {
        layoutView()
    }
    
    func dismissHistoryKeyboard() {
        delegate.dismissHistoryKeyboard()
    }
    
}

extension SearchHistoryViewController: SearchHistoryTableDelegate {
    
    // MARK: - Table View Controller Delegate Methods
    
    var queryCellViewModels: Array<QueryCellViewModel> { return viewModel.queryCellViewModels }
    
    func add(queryCellViewModel: QueryCellViewModel) {
        viewModel.add(queryCellViewModel: queryCellViewModel)
        delegate.historySearch(with: queryCellViewModel.query)
    }
    
    func delete(queryCellViewModel: QueryCellViewModel) {
        viewModel.delete(queryCellViewModel: queryCellViewModel)
        synchronizeTableView()
    }
    
    func updateTable() {
        updateTableView()
    }
    
    func didUpdateTable() {
        layoutView()
    }
    
}
