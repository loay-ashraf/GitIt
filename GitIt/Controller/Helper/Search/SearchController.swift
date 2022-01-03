//
//  SearchController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class SearchController<Type: Model>: UISearchController, UISearchControllerDelegate, UISearchBarDelegate {

    private weak var coordinator: SearchCoordinator<Type>!
    private lazy var timer = SearchTimer { [weak self] in self?.timerSearch() }
    var keyword: String {
        get { return searchBar.text! }
        set { searchBar.text = newValue }
    }
    
    // MARK: - Initialisation

    init(_ coordinator: SearchCoordinator<Type>, searchResultsController: UIViewController) {
        super.init(searchResultsController: searchResultsController)
        self.coordinator = coordinator
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Search Controller Helper Methods
    
    private func configure() {
        delegate = self
        searchBar.delegate = self
        obscuresBackgroundDuringPresentation = true
        searchBar.placeholder = "Search All Users"
        searchBar.autocapitalizationType = .none
        obscuresBackgroundDuringPresentation = false
        showsSearchResultsController = true
    }
    
    private func timerSearch() {
        timer.cancel()
        coordinator.willSearch()
    }

    // MARK: - Search Controller Delegate
    
    func didPresentSearchController(_ searchController: UISearchController) {
        coordinator.didBeginSearchingSession()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        coordinator.didEndSearchingSession()
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            timer.activate()
        } else {
            timer.cancel()
            coordinator.didSearch()
        }
    }

}
