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

extension SearchCoordinator: HistoryDelegate {
    
    // MARK: - History Delegate Methods
    
    func historySearch(with keyword: String) {
        self.keyword = keyword
        render(.searching)
        resultsController.loadResults(with: keyword)
    }
    
    func dismissHistoryKeyboard() {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
}

extension SearchCoordinator: ResultsDelegate {
    
    // MARK: - Results Delegate Methods
    
    func addModel(with model: Any) {
        historyController.addModel(with: model)
    }
    
    func dismissResultsKeyboard() {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
}
