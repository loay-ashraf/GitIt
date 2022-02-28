//
//  SearchCoordinator.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

class SearchCoordinator<T: SearchModule> {
    
    // MARK: - Properties
    
    var query: String {
        get { return searchController.query }
        set { searchController.query = newValue }
    }
    
    var searchController: SearchController!
    var searchHistoryController: SearchHistoryViewController<T.SearchHistoryViewModelType>!
    var searchResultsController: SearchResultsViewController<T.SearchResultsViewModelType>!
    
    var navigationController: UINavigationController!
    
    // MARK: - Initialization
    
    init(_ parentTableViewController: UITableViewController) {
        searchHistoryController = SearchHistoryViewController.instatiateFromStoryboard(with: self)
        searchResultsController = SearchResultsViewController.instatiateFromStoryboard(with: self)
        navigationController = UINavigationController(rootViewController: searchHistoryController)
        searchController = SearchController(self, searchBarPlaceholder: T.searchBarPlaceholder, searchResultsController: navigationController)
        parentTableViewController.navigationItem.searchController = searchController
        parentTableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        parentTableViewController.definesPresentationContext = true
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }
    
}

final class UserSearchModule: SearchModule {
    
    typealias SearchHistoryViewModelType = UserSearchHistoryViewModel
    typealias SearchResultsViewModelType = UserSearchResultsViewModel
    
    static var searchBarPlaceholder = ViewConstants.SearchBar.users
    
}

final class RepositorySearchModule: SearchModule {
    
    typealias SearchHistoryViewModelType = RepositorySearchHistoryViewModel
    typealias SearchResultsViewModelType = RepositorySearchResultsViewModel
    
    static var searchBarPlaceholder = ViewConstants.SearchBar.repositories
    
}

final class OrganizationSearchModule: SearchModule {
    
    typealias SearchHistoryViewModelType = OrganizationSearchHistoryViewModel
    typealias SearchResultsViewModelType = OrganizationSearchResultsViewModel
    
    static var searchBarPlaceholder = ViewConstants.SearchBar.organizations
    
}
