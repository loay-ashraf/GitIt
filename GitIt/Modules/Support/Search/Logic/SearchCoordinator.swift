//
//  SearchCoordinator.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

class SearchCoordinator<T: SearchStackType> {
    
    // MARK: - Properties
    
    var query: String {
        get { return searchController.query }
        set { searchController.query = newValue }
    }
    
    var searchController: SearchController!
    var historyController: SearchHistoryViewController<T.SearchHistoryViewModelType>!
    var resultsController: SearchResultsViewController<T.SearchResultsViewModelType>!
    
    var navigationController: UINavigationController!
    
    // MARK: - Initialization
    
    init(_ parentTableViewController: UITableViewController) {
        historyController = SearchHistoryViewController.instatiateFromStoryboard(with: self)
        resultsController = SearchResultsViewController.instatiateFromStoryboard(with: self)
        navigationController = UINavigationController(rootViewController: historyController)
        searchController = SearchController(self, searchContext: T.context, searchResultsController: navigationController)
        parentTableViewController.navigationItem.searchController = searchController
        parentTableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        parentTableViewController.definesPresentationContext = true
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }
    
}

final class UserSearchStack: SearchStackType {
    
    typealias SearchResultsViewModelType = UserSearchResultsViewModel
    typealias SearchHistoryViewModelType = UserSearchHistoryViewModel
    
    static var context = SearchContext.users
    
}

final class RepositorySearchStack: SearchStackType {
    
    typealias SearchResultsViewModelType = RepositorySearchResultsViewModel
    typealias SearchHistoryViewModelType = RepositorySearchHistoryViewModel
    
    static var context = SearchContext.repositories
    
}

final class OrganizationSearchStack: SearchStackType {
    
    typealias SearchResultsViewModelType = OrganizationSearchResultsViewModel
    typealias SearchHistoryViewModelType = OrganizationSearchHistoryViewModel
    
    static var context = SearchContext.organizations
    
}
