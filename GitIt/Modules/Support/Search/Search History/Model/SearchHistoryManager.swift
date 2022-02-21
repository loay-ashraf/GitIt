//
//  SearchHistoryManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 13/01/2022.
//

import Foundation

class SearchHistoryManager: DataPersistenceManager {
    
    // MARK: - Properties
    
    typealias DataPersistenceProviderType = FileManagerPersistenceProvider
    
    static let standard = SearchHistoryManager()
    let dataPersistenceProvider = DataManager.standard.fileManagerPersistenceProvider
    
    var userHistory = SearchHistory<UserModel>()
    var repositoryHistory = SearchHistory<RepositoryModel>()
    var organizationHistory = SearchHistory<OrganizationModel>()
    
    var activeSearchContext: SearchContext!
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Save and Load Methods
    
    func save() throws {
        try dataPersistenceProvider.writeJSONFile(with: userHistory, at: Constants.Model.SearchHistory.userURL)
        try dataPersistenceProvider.writeJSONFile(with: repositoryHistory, at: Constants.Model.SearchHistory.repositoryURL)
        try dataPersistenceProvider.writeJSONFile(with: organizationHistory, at: Constants.Model.SearchHistory.organizationURL)
    }
    
    func load() throws {
        do {
            userHistory = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.userURL).get()
            repositoryHistory = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.repositoryURL).get()
            organizationHistory = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.organizationURL).get()
        } catch let error as FileManagerError {
            switch error {
            case FileManagerError.fileDoesNotExist: break
            default: throw error
            }
        }
    }
    
    // MARK: - Add Methods
    
    func add<Type: Model>(model: Type) {
        switch model {
        case let model as UserModel: userHistory.objects.removeAll() { value in return value == model }
                                     userHistory.objects.insert(model, at: 0)
        case let model as RepositoryModel: repositoryHistory.objects.removeAll() { value in return value == model }
                                           repositoryHistory.objects.insert(model, at: 0)
        case let model as OrganizationModel: organizationHistory.objects.removeAll() { value in return value == model }
                                             organizationHistory.objects.insert(model, at: 0)
        default: break
        }
    }
    
    func add<Type: Model>(keyword: String, for modelType: Type.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.queries.removeAll() { value in return value == keyword }
                                userHistory.queries.insert(keyword, at: 0)
        case is RepositoryModel.Type: repositoryHistory.queries.removeAll() { value in return value == keyword }
                                      repositoryHistory.queries.insert(keyword, at: 0)
        case is OrganizationModel.Type: organizationHistory.queries.removeAll() { value in return value == keyword }
                                        organizationHistory.queries.insert(keyword, at: 0)
        default: break
        }
    }
    
    // MARK: - Delete Methods
    
    func delete<Type: Model>(model: Type) {
        switch model {
        case let model as UserModel: userHistory.objects.removeAll() { value in return value == model }
        case let model as RepositoryModel: repositoryHistory.objects.removeAll() { value in return value == model }
        case let model as OrganizationModel: organizationHistory.objects.removeAll() { value in return value == model }
        default: break
        }
    }
    
    func delete<Type: Model>(keyword: String, for modelType: Type.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.queries.removeAll() { value in return value == keyword }
        case is RepositoryModel.Type: repositoryHistory.queries.removeAll() { value in return value == keyword }
        case is OrganizationModel.Type: organizationHistory.queries.removeAll() { value in return value == keyword }
        default: break
        }
    }
    
    // MARK: - Clear Methods
    
    func clear<Type: Model>(for modelType: Type.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.clear()
        case is RepositoryModel.Type: repositoryHistory.clear()
        case is OrganizationModel.Type: organizationHistory.clear()
        default: break
        }
    }
    
    func clearActive() {
        switch activeSearchContext {
        case .users: userHistory.clear()
        case .repositories: repositoryHistory.clear()
        case .organizations: organizationHistory.clear()
        default: break
        }
    }
    
    func clearAll() {
        userHistory.clear()
        repositoryHistory.clear()
        organizationHistory.clear()
    }
    
}
