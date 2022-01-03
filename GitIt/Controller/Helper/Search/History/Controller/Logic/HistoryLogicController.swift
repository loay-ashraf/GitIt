//
//  HistoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation
import UIKit

class HistoryLogicController<Type: Model> {
    
    var history = SearchHistory<Type>()
    
    private var handler: LoadingHandler?
    
    // MARK: - Save Methods
    
    func save() {
        switch Type.self {
        case is UserModel.Type: saveUserSearchHistory()
        case is RepositoryModel.Type: saveRepositorySearchHistory()
        case is OrganizationModel.Type: saveOrganizationSearchHistory()
        default: return
        }
    }
    
    private func saveUserSearchHistory() {
        let saveError = LibraryManager.standard.saveUserSearchHistory(searchHistory: history as! SearchHistory<UserModel>)
        saveHandler(error: saveError)
    }
    
    private func saveRepositorySearchHistory() {
        let saveError = LibraryManager.standard.saveRepositorySearchHistory(searchHistory: history as! SearchHistory<RepositoryModel>)
        saveHandler(error: saveError)
    }
    
    private func saveOrganizationSearchHistory() {
        let saveError = LibraryManager.standard.saveOrganizationSearchHistory(searchHistory: history as! SearchHistory<OrganizationModel>)
        saveHandler(error: saveError)
    }
    
    private func saveHandler(error: Error?) {
        if error != nil {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            AlertHelper.showAlert(title: "Save Error", message: "An error occured while saving your search history, We're aware of the issue and working on it.", style: .alert, actions: [okAction])
        }
    }
    
    // MARK: - Load Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        switch Type.self {
        case is UserModel.Type: loadUserSearchHistory()
        case is RepositoryModel.Type: loadRepositorySearchHistory()
        case is OrganizationModel.Type: loadOrganizationSearchHistory()
        default: return
        }
    }
    
    private func loadUserSearchHistory() {
        let result = LibraryManager.standard.loadUserSearchHistory()
        processResult(result: result as! Result<SearchHistory<Type>,LibraryError>)
    }
    
    private func loadRepositorySearchHistory() {
        let result = LibraryManager.standard.loadRepositorySearchHistory()
        processResult(result: result as! Result<SearchHistory<Type>,LibraryError>)
    }
    
    private func loadOrganizationSearchHistory() {
        let result = LibraryManager.standard.loadOrganizationSearchHistory()
        processResult(result: result as! Result<SearchHistory<Type>,LibraryError>)
    }
    
    private func processResult(result: Result<SearchHistory<Type>,LibraryError>) {
        switch result {
        case .success(let searchHistory): history = searchHistory
                                          if history.models.isEmpty, history.keywords.isEmpty {
                                              handler?(nil,.searchHistory)
                                          } else {
                                              handler?(nil,nil)
                                          }
        case .failure(let libraryError): handler?(libraryError, nil)
        }
    }
    
    // MARK: - History Manipulationn Methods
    
    func addToHistory(model: Type) {
        history.models.removeAll() { value in return value == model }
        history.models.insert(model, at: 0)
        save()
    }
    
    func addToHistory(keyWord: String) {
        history.keywords.removeAll() { value in return value == keyWord }
        history.keywords.insert(keyWord, at: 0)
        save()
    }
    
    func deleteFromHistory(model: Type) {
        history.models.removeAll() { value in return value == model }
        save()
    }
    
    func deleteFromHistory(keyWord: String) {
        history.keywords.removeAll() { value in return value == keyWord }
        save()
    }
    
    func clearHistory() {
        history.models.removeAll()
        history.keywords.removeAll()
        save()
    }
    
}
