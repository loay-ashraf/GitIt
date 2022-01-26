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
    var resultsController: SearchResultsViewController<Type>!
    var historyController: SearchHistoryViewController<Type>!
    
    var navigationController: UINavigationController!
    
    // MARK: - Initialisation
    
    init(_ parentTableViewController: SFDynamicTableViewController<Type>) {
        historyController = SearchHistoryViewController.instatiateFromStoryboard(with: self)
        resultsController = SearchResultsViewController.instatiateFromStoryboard(with:self)
        navigationController = UINavigationController(rootViewController: historyController)
        searchController = SearchController(self, searchResultsController: navigationController)
        parentTableViewController.navigationItem.searchController = searchController
        parentTableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        parentTableViewController.definesPresentationContext = true
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }
    
    // MARK: - Search Controller Outlet Methods
    
    func didBeginSearchingSession() {
        render(.idle)
    }
    
    func didEndSearchingSession() {
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
        resetControllers()
    }
    
}
