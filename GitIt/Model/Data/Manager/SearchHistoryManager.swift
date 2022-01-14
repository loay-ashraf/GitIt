//
//  SearchHistoryManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 13/01/2022.
//

import Foundation

class SearchHistoryManager {
    
    static let standard = SearchHistoryManager()
    let fileManagerHelper = DataManager.standard.fileManagerHelper
    
    var userHistory = SearchHistory<UserModel>()
    var repositoryHistory = SearchHistory<RepositoryModel>()
    var organizationHistory = SearchHistory<OrganizationModel>()
    
    // MARK: - Initialisation
    
    private init() {}
    
    // MARK: - Save and Load Methods
    
    func save() throws {
        try fileManagerHelper.writeJSONFile(with: userHistory, at: Constants.Model.SearchHistory.userURL)
        try fileManagerHelper.writeJSONFile(with: repositoryHistory, at: Constants.Model.SearchHistory.repositoryURL)
        try fileManagerHelper.writeJSONFile(with: organizationHistory, at: Constants.Model.SearchHistory.organizationURL)
    }
    
    func load() throws {
        do {
            userHistory = try fileManagerHelper.readJSONFile(at: Constants.Model.SearchHistory.userURL).get()
            repositoryHistory = try fileManagerHelper.readJSONFile(at: Constants.Model.SearchHistory.repositoryURL).get()
            organizationHistory = try fileManagerHelper.readJSONFile(at: Constants.Model.SearchHistory.organizationURL).get()
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
        case let model as UserModel: userHistory.models.removeAll() { value in return value == model }
                                     userHistory.models.insert(model, at: 0)
        case let model as RepositoryModel: repositoryHistory.models.removeAll() { value in return value == model }
                                           repositoryHistory.models.insert(model, at: 0)
        case let model as OrganizationModel: organizationHistory.models.removeAll() { value in return value == model }
                                             organizationHistory.models.insert(model, at: 0)
        default: break
        }
    }
    
    func add<Type: Model>(keyword: String, for modelType: Type.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.keywords.removeAll() { value in return value == keyword }
                                userHistory.keywords.insert(keyword, at: 0)
        case is RepositoryModel.Type: repositoryHistory.keywords.removeAll() { value in return value == keyword }
                                      repositoryHistory.keywords.insert(keyword, at: 0)
        case is OrganizationModel.Type: organizationHistory.keywords.removeAll() { value in return value == keyword }
                                        organizationHistory.keywords.insert(keyword, at: 0)
        default: break
        }
    }
    
    // MARK: - Delete Methods
    
    func delete<Type: Model>(model: Type) {
        switch model {
        case let model as UserModel: userHistory.models.removeAll() { value in return value == model }
        case let model as RepositoryModel: repositoryHistory.models.removeAll() { value in return value == model }
        case let model as OrganizationModel: organizationHistory.models.removeAll() { value in return value == model }
        default: break
        }
    }
    
    func delete<Type: Model>(keyword: String, for modelType: Type.Type) {
        switch modelType.self {
        case is UserModel.Type: userHistory.keywords.removeAll() { value in return value == keyword }
        case is RepositoryModel.Type: repositoryHistory.keywords.removeAll() { value in return value == keyword }
        case is OrganizationModel.Type: organizationHistory.keywords.removeAll() { value in return value == keyword }
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
    
    func clearAll() {
        userHistory.clear()
        repositoryHistory.clear()
        organizationHistory.clear()
    }
    
}
