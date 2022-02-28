//
//  SearchController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class SearchController: UISearchController, UISearchControllerDelegate, UISearchBarDelegate {

    // MARK: - Properties
    
    private weak var controllerDelegate: SearchControllerDelegate!
    private var searchBarPlaceholder: String!
    private lazy var searchTimer = SearchTimer { [weak self] in self?.timerSearch() }
    var query: String {
        get { return searchBar.text! }
        set { searchBar.text = newValue }
    }
    
    // MARK: - Initialization

    init(_ controllerDelegate: SearchControllerDelegate, searchBarPlaceholder: String, searchResultsController: UIViewController) {
        super.init(searchResultsController: searchResultsController)
        self.controllerDelegate = controllerDelegate
        self.searchBarPlaceholder = searchBarPlaceholder
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }

    // MARK: - Search Controller Helper Methods
    
    private func configure() {
        delegate = self
        searchBar.delegate = self
        searchBar.placeholder = searchBarPlaceholder
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchTextField.backgroundColor = UIColor(named: "Foreground Color")
        obscuresBackgroundDuringPresentation = false
        showsSearchResultsController = true
    }
    
    private func timerSearch() {
        searchTimer.cancel()
        controllerDelegate.willSearch()
    }

    // MARK: - Search Controller Delegate
    
    func didPresentSearchController(_ searchController: UISearchController) {
        controllerDelegate.didBeginSearchingSession()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        controllerDelegate.didEndSearchingSession()
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchTimer.activate()
        } else {
            searchTimer.cancel()
            controllerDelegate.didSearch()
        }
    }

}
