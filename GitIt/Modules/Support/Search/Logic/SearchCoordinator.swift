//
//  SearchCoordinator.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

class SearchCoordinator<Type: Model> {
    
    var keyword: String {
        get { return searchController.keyword }
        set { searchController.keyword = newValue }
    }
    
    var searchController: SearchController<Type>!
    var resultsController: ResultsViewController<Type>!
    var historyController: HistoryViewController<Type>!
    
    var navigationController: UINavigationController!
    
    // MARK: - Initialisation
    
    init(_ parentTableViewController: SFDynamicTableViewController<Type>) {
        resultsController = ResultsViewController.instatiateFromStoryboard(with:self)
        historyController = HistoryViewController.instatiateFromStoryboard(with: self)
        navigationController = UINavigationController(rootViewController: historyController)
        searchController = SearchController(self, searchResultsController: navigationController)
        parentTableViewController.navigationItem.searchController = searchController
        parentTableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        parentTableViewController.definesPresentationContext = true
    }
    
    // MARK: - Search Controller Outlet Methods
    
    func didBeginSearchingSession() {
        subViewsOffsetSize = .searchScreen
        render(.idle)
    }
    
    func didEndSearchingSession() {
        subViewsOffsetSize = .mainScreenWithSearch
        keyword = ""
        render(.idle)
        resetControllers()
    }
    
    func willSearch() {
        render(.searching)
        historyController.addKeyword(with: keyword)
        resultsController.loadResults(with: keyword)
    }
    
    func didSearch() {
        render(.idle)
    }
    
}