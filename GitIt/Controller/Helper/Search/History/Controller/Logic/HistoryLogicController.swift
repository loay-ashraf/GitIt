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
        history = SearchHistoryManager.standard.userHistory as! SearchHistory<Type>
        if history.models.isEmpty, history.keywords.isEmpty {
            handler?(nil,.searchHistory)
        } else {
            handler?(nil,nil)
        }
    }
    
    private func loadRepositorySearchHistory() {
        history = SearchHistoryManager.standard.repositoryHistory as! SearchHistory<Type>
        if history.models.isEmpty, history.keywords.isEmpty {
            handler?(nil,.searchHistory)
        } else {
            handler?(nil,nil)
        }
    }
    
    private func loadOrganizationSearchHistory() {
        history = SearchHistoryManager.standard.organizationHistory as! SearchHistory<Type>
        if history.models.isEmpty, history.keywords.isEmpty {
            handler?(nil,.searchHistory)
        } else {
            handler?(nil,nil)
        }
    }
    
    private func synchronize() {
        switch Type.self {
        case is UserModel.Type: history = SearchHistoryManager.standard.userHistory as! SearchHistory<Type>
        case is RepositoryModel.Type: history = SearchHistoryManager.standard.repositoryHistory as! SearchHistory<Type>
        case is OrganizationModel.Type: history = SearchHistoryManager.standard.organizationHistory as! SearchHistory<Type>
        default: return
        }
    }
    
    // MARK: - History Manipulationn Methods
    
    func add(model: Type) {
        SearchHistoryManager.standard.add(model: model)
        synchronize()
    }
    
    func add(keyword: String) {
        SearchHistoryManager.standard.add(keyword: keyword, for: Type.self)
        synchronize()
    }
    
    func delete(model: Type) {
        SearchHistoryManager.standard.delete(model: model)
        synchronize()
    }
    
    func delete(keyword: String) {
        SearchHistoryManager.standard.delete(keyword: keyword, for: Type.self)
        synchronize()
    }
    
    func clear() {
        SearchHistoryManager.standard.clear(for: Type.self)
        synchronize()
    }
    
}
