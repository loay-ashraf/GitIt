//
//  SearchCoordinatorExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import UIKit

extension SearchCoordinator {
    
    // MARK: - View Helper Methods
    
    func render(_ state: SearchUIState) {
        switch state {
        case .searching: showResults()
                         resetNavigationController()
        case .idle: hideResults()
                    resetNavigationController()
        }
    }
    
    func resetNavigationController() {
        navigationController.popToRootViewController(animated: false)
    }
    
    func resetControllers() {
        historyController.reset()
        resultsController.reset()
    }
    
    func showResults() {
        UIView.transition(with: historyController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.historyController.addChild(self.resultsController)
            self.historyController.view.addSubview(self.resultsController.view)
            self.resultsController.didMove(toParent: self.historyController!)
            self.resultsController.view.frame = self.historyController.view.frame
        }, completion: nil)
    }
    
    func hideResults() {
        UIView.transition(with: historyController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.resultsController.willMove(toParent: nil)
            self.resultsController.removeFromParent()
            self.resultsController.view.removeFromSuperview()
        }, completion: nil)
    }
    
}

extension SearchCoordinator: SearchControllerDelegate {
    
    // MARK: - Search Controller Delegate Methods
    
    func didBeginSearchingSession() {
        render(.idle)
    }
    
    func didEndSearchingSession() {
        query = ""
        render(.idle)
        resetControllers()
    }
    
    func willSearch() {
        render(.searching)
        historyController.addQuery(with: query)
        resultsController.loadResults(with: query)
    }
    
    func didSearch() {
        render(.idle)
        resetControllers()
    }
    
}

extension SearchCoordinator: SearchHistoryDelegate {
    
    // MARK: - History Delegate Methods
    
    func historySearch(with keyword: String) {
        self.query = keyword
        render(.searching)
        resultsController.loadResults(with: keyword)
    }
    
    func dismissHistoryKeyboard() {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
}

extension SearchCoordinator: SearchResultsDelegate {
    
    // MARK: - Results Delegate Methods
    
    func addObject<T: TableCellViewModel>(with cellViewModel: T) {
        let collectionCellViewModel = cellViewModel.collectionCellViewModel()
        historyController.addObject(with: collectionCellViewModel)
    }
    
    func dismissResultsKeyboard() {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
}
