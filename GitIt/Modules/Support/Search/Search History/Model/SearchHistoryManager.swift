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
    
    private var userHistory = Observable<SearchHistory<UserModel>>()
    private var repositoryHistory = Observable<SearchHistory<RepositoryModel>>()
    private var organizationHistory = Observable<SearchHistory<OrganizationModel>>()
    
    var activeSearchContext: SearchContext!
    
    // MARK: - Initialization
    
    private init() {
        userHistory.value = SearchHistory<UserModel>()
        repositoryHistory.value = SearchHistory<RepositoryModel>()
        organizationHistory.value = SearchHistory<OrganizationModel>()
    }
    
    // MARK: - Save and Load Methods
    
    func save() throws {
        try dataPersistenceProvider.writeJSONFile(with: userHistory.value, at: Constants.Model.SearchHistory.userURL)
        try dataPersistenceProvider.writeJSONFile(with: repositoryHistory.value, at: Constants.Model.SearchHistory.repositoryURL)
        try dataPersistenceProvider.writeJSONFile(with: organizationHistory.value, at: Constants.Model.SearchHistory.organizationURL)
    }
    
    func load() throws {
        do {
            userHistory.value = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.userURL).get()
            repositoryHistory.value = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.repositoryURL).get()
            organizationHistory.value = try dataPersistenceProvider.readJSONFile(at: Constants.Model.SearchHistory.organizationURL).get()
        } catch let error as FileManagerError {
            switch error {
            case FileManagerError.fileDoesNotExist: break
            default: throw error
            }
        }
    }
    
    // MARK: - Add Methods
    
    func add<T: Model>(model: T) {
        switch model {
        case let model as UserModel: userHistory.value?.objects.removeAll() { value in return value == model }
                                     userHistory.value?.objects.insert(model, at: 0)
        case let model as RepositoryModel: repositoryHistory.value?.objects.removeAll() { value in return value == model }
                                           repositoryHistory.value?.objects.insert(model, at: 0)
        case let model as OrganizationModel: organizationHistory.value?.objects.removeAll() { value in return value == model }
                                             organizationHistory.value?.objects.insert(model, at: 0)
        default: break
        }
    }
    
    func add<T: Model>(keyword: String, for modelType: T.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.value?.queries.removeAll() { value in return value == keyword }
                                userHistory.value?.queries.insert(keyword, at: 0)
        case is RepositoryModel.Type: repositoryHistory.value?.queries.removeAll() { value in return value == keyword }
                                      repositoryHistory.value?.queries.insert(keyword, at: 0)
        case is OrganizationModel.Type: organizationHistory.value?.queries.removeAll() { value in return value == keyword }
                                        organizationHistory.value?.queries.insert(keyword, at: 0)
        default: break
        }
    }
    
    // MARK: - Delete Methods
    
    func delete<Type: Model>(model: Type) {
        switch model {
        case let model as UserModel: userHistory.value?.objects.removeAll() { value in return value == model }
        case let model as RepositoryModel: repositoryHistory.value?.objects.removeAll() { value in return value == model }
        case let model as OrganizationModel: organizationHistory.value?.objects.removeAll() { value in return value == model }
        default: break
        }
    }
    
    func delete<T: Model>(keyword: String, for modelType: T.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.value?.queries.removeAll() { value in return value == keyword }
        case is RepositoryModel.Type: repositoryHistory.value?.queries.removeAll() { value in return value == keyword }
        case is OrganizationModel.Type: organizationHistory.value?.queries.removeAll() { value in return value == keyword }
        default: break
        }
    }
    
    // MARK: - Clear Methods
    
    func clear<T: Model>(for modelType: T.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.value?.clear()
        case is RepositoryModel.Type: repositoryHistory.value?.clear()
        case is OrganizationModel.Type: organizationHistory.value?.clear()
        default: break
        }
    }
    
    func clearActive() {
        switch activeSearchContext {
        case .users: userHistory.value?.clear()
        case .repositories: repositoryHistory.value?.clear()
        case .organizations: organizationHistory.value?.clear()
        default: break
        }
    }
    
    func clearAll() {
        userHistory.value?.clear()
        repositoryHistory.value?.clear()
        organizationHistory.value?.clear()
    }
    
    // MARK: - Bind Methods
    
    func bindUsers(_ listener: @escaping (SearchHistory<UserModel>?) -> Void) {
        userHistory.bind(listener)
    }
    
    func bindRepositories(_ listener: @escaping (SearchHistory<RepositoryModel>?) -> Void) {
        repositoryHistory.bind(listener)
    }
    
    func bindOrganizations(_ listener: @escaping (SearchHistory<OrganizationModel>?) -> Void) {
        organizationHistory.bind(listener)
    }
    
}
