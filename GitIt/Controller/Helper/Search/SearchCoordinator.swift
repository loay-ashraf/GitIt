//
//  SearchCoordinator.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit
import CoreData

class SearchCoordinator<Type: Model> {
    
    var results: List<Type> = List()
    private var searchController: SearchController<Type>!
    private var resultsController: ResultsViewController<Type>!
    private var historyController: HistoryViewController<Type>!
    private var spinner: Spinner!
    var resultsTableView: UITableView {
        return resultsController.tableView
    }
    
    private var searchHistory: SearchHistory<Type>!
    var searchHistoryModels: NSMutableOrderedSet!
    var searchHistoryKeywords: NSMutableOrderedSet!
    
    // MARK: - Initialisation
    
    init(_ parentTableViewController: UITableViewController) {
        resultsController = ResultsViewController(self)
        historyController = HistoryViewController(self)
        searchController = SearchController(self, searchResultsController: resultsController)
        spinner = Spinner(resultsController)
        parentTableViewController.navigationItem.searchController = searchController
        parentTableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        parentTableViewController.definesPresentationContext = true
        loadHistory()
    }
    
}

extension SearchCoordinator {
    
    // MARK: - Search Helper Methods
    
    func search() {
        switch Type.self {
        case is UserModel.Type: GithubClient.standard.getUserSearchPage(keyword: searchController.keyword, page: results.currentPage, perPage: 10, completion: processUser(response:error:))
        case is RepositoryModel.Type: GithubClient.standard.getRepositorySearchPage(keyword: searchController.keyword, page: results.currentPage, perPage: 10, completion: processRepository(response:error:))
        case is OrganizationModel.Type: GithubClient.standard.getOrganizationSearchPage(keyword: searchController.keyword, page: results.currentPage, perPage: 10, completion: processOrganization(response:error:))
        default: print("dummy")
        }
    }
    
    func paginate() {
        let lastRowIndex = resultsController.tableView.indexPathsForVisibleRows?.last?.row
        if let lastRowIndex = lastRowIndex {
            if results.isPaginable, !spinner.isActive, lastRowIndex + 1 == results.items.count {
                render(.paginating)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.search()
                }
            }
        }
    }
    
    func historySearch(keyWord: String) {
        searchController.keyword = keyWord
        render(.searching)
        search()
    }
    
    func didBeginSearchingSession() {
        render(.notSearching)
    }
    
    func didEndSearchingSession() {
        reset()
    }
    
    func willSearch() {
        addToHistory(keyWord: searchController.keyword)
        historyController.updateUI()
        render(.searching)
    }
    
    func didSearch() {
        render(.notSearching)
    }
    
    func willPresentModel(model: Type) {
        addToHistory(model: model)
        historyController.updateUI()
    }
    
    private func reset() {
        searchController.keyword = ""
        results.reset()
        render(.presenting)
    }
    
    private func updateModelProperties(count: Int) {
        results.currentPage += 1
        if !results.isPaginable {
            results.isPaginable = count > 10 ? true : false
        } else {
            results.isPaginable = results.items.count == count ? false : true
        }
    }
    
    private func processUser(response: BatchResponse<UserModel>?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            results.append(contentsOf: response!.items as! [Type])
            updateModelProperties(count: response!.count)
            render(.presenting)
        }
    }

    private func processRepository(response: BatchResponse<RepositoryModel>?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            results.append(contentsOf: response!.items as! [Type])
            updateModelProperties(count: response!.count)
            render(.presenting)
        }
    }
    
    private func processOrganization(response: BatchResponse<OrganizationModel>?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            results.append(contentsOf: response!.items as! [Type])
            updateModelProperties(count: response!.count)
            render(.presenting)
        }
    }
    
}

extension SearchCoordinator {
    
    // MARK: - Search History Helper Methods
    
    private func saveHistory() {
        searchHistory.models = searchHistoryModels.array as! [Type]
        searchHistory.keywords = searchHistoryKeywords.array as! [String]
        switch Type.self {
        case is UserModel.Type: DataManager.shared.saveUserSearchHistory(searchHistory: searchHistory as! SearchHistory<UserModel>)
        case is RepositoryModel.Type: DataManager.shared.saveRepositorySearchHistory(searchHistory: searchHistory as! SearchHistory<RepositoryModel>)
        case is OrganizationModel.Type: DataManager.shared.saveOrganizationSearchHistory(searchHistory: searchHistory as! SearchHistory<OrganizationModel>)
        default: return
        }
    }
    
    private func loadHistory() {
        switch Type.self {
        case is UserModel.Type: searchHistory = DataManager.shared.loadUserSearchHistory() as? SearchHistory<Type>
        case is RepositoryModel.Type: searchHistory = DataManager.shared.loadRepositorySearchHistory() as? SearchHistory<Type>
        case is OrganizationModel.Type: searchHistory = DataManager.shared.loadOrganizationSearchHistory() as? SearchHistory<Type>
        default: return
        }
        if searchHistory == nil {
            searchHistory = SearchHistory<Type>()
            searchHistoryModels = NSMutableOrderedSet()
            searchHistoryKeywords = NSMutableOrderedSet()
        } else {
            searchHistoryModels = NSMutableOrderedSet(array: searchHistory.models)
            searchHistoryKeywords = NSMutableOrderedSet(array: searchHistory.keywords)
        }
    }
    
    func addToHistory(model: Type) {
        let index = searchHistoryModels.array.firstIndex { $0 as! Type == model }
        index != nil ? searchHistoryModels.removeObject(at: index!) : nil
        searchHistoryModels.insert(model, at: 0)
        saveHistory()
    }
    
    func addToHistory(keyWord: String) {
        searchHistoryKeywords.remove(keyWord)
        searchHistoryKeywords.insert(keyWord, at: 0)
        saveHistory()
    }
    
    func deleteFromHistory(model: Type) {
        let index = searchHistoryModels.array.firstIndex { $0 as! Type == model }
        index != nil ? searchHistoryModels.removeObject(at: index!) : nil
        saveHistory()
    }
    
    func deleteFromHistory(keyWord: String) {
        searchHistoryKeywords.remove(keyWord)
        saveHistory()
    }
    
    func clearHistory() {
        searchHistoryKeywords.removeAllObjects()
        searchHistoryModels.removeAllObjects()
        saveHistory()
    }
    
}

extension SearchCoordinator {
    
    // MARK: - UI Helper Methods
    
    private func render(_ state: SearchViewState) {
        switch state {
        case .searching: hideHistory()
                         showSpinner(viewState: state)
        case .notSearching: showHistory()
        case .paginating: showSpinner(viewState: state)
        case .presenting: hideSpinner()
                          updateUI()
        case .failed(let error): print(error)
        }
    }
    
    private func updateUI() {
        resultsTableView.reloadData()
    }
    
    private func showHistory() {
        resultsController.addChild(historyController)
        resultsController.view.addSubview(historyController.view)
        historyController.didMove(toParent: resultsController!)
        historyController.view.frame = resultsController.view.frame
        resultsTableView.bounces = false
    }
    
    private func hideHistory() {
        historyController.willMove(toParent: nil)
        historyController.removeFromParent()
        historyController.view.removeFromSuperview()
        resultsTableView.bounces = true
    }
    
    private func showSpinner(viewState: SearchViewState) {
        switch viewState {
            case .searching: spinner.showMainSpinner()
            case .paginating: spinner.showFooterSpinner()
            default: return
        }
    }
    
    private func hideSpinner() {
        spinner.hideMainSpinner()
        spinner.hideFooterSpinner()
        resultsTableView.refreshControl?.endRefreshing()
    }
    
}
