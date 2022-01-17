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
    var historyManager = SearchHistoryManager.standard
    
    private var handler: LoadingHandler?
    
    init() {
        let searchContext = SearchContext(from: Type.self)
        historyManager.activeSearchContext = searchContext
    }
    
    // MARK: - Load Methods
    
    func load(handler: @escaping LoadingHandler) {
        self.handler = handler
        switch Type.self {
        case is UserModel.Type: loadUserSearchHistory()
        case is RepositoryModel.Type: loadRepositorySearchHistory()
        case is OrganizationModel.Type: loadOrganizationSearchHistory()
        default: return
        }
    }
    
    private func loadUserSearchHistory() {
        history = historyManager.userHistory as! SearchHistory<Type>
        handler?(nil)
    }
    
    private func loadRepositorySearchHistory() {
        history = historyManager.repositoryHistory as! SearchHistory<Type>
        handler?(nil)
    }
    
    private func loadOrganizationSearchHistory() {
        history = historyManager.organizationHistory as! SearchHistory<Type>
        handler?(nil)
    }
    
    private func synchronize() {
        switch Type.self {
        case is UserModel.Type: history = historyManager.userHistory as! SearchHistory<Type>
        case is RepositoryModel.Type: history = historyManager.repositoryHistory as! SearchHistory<Type>
        case is OrganizationModel.Type: history = historyManager.organizationHistory as! SearchHistory<Type>
        default: return
        }
    }
    
    // MARK: - History Manipulationn Methods
    
    func add(model: Type) {
        historyManager.add(model: model)
        synchronize()
    }
    
    func add(keyword: String) {
        historyManager.add(keyword: keyword, for: Type.self)
        synchronize()
    }
    
    func delete(model: Type) {
        historyManager.delete(model: model)
        synchronize()
    }
    
    func delete(keyword: String) {
        historyManager.delete(keyword: keyword, for: Type.self)
        synchronize()
    }
    
    func clear() {
        historyManager.clear(for: Type.self)
        synchronize()
    }
    
}
