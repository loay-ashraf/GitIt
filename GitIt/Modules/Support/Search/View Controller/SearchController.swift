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
    private var searchContext: SearchContext!
    private lazy var timer = SearchTimer { [weak self] in self?.timerSearch() }
    var query: String {
        get { return searchBar.text! }
        set { searchBar.text = newValue }
    }
    
    // MARK: - Initialization

    init(_ controllerDelegate: SearchControllerDelegate, searchContext: SearchContext, searchResultsController: UIViewController) {
        super.init(searchResultsController: searchResultsController)
        self.controllerDelegate = controllerDelegate
        self.searchContext = searchContext
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
        searchBar.placeholder = searchContext.barPlaceholder
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchTextField.backgroundColor = UIColor(named: "Foreground Color")
        obscuresBackgroundDuringPresentation = false
        showsSearchResultsController = true
    }
    
    private func timerSearch() {
        timer.cancel()
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
            timer.activate()
        } else {
            timer.cancel()
            controllerDelegate.didSearch()
        }
    }

}
