//
//  BookmarksManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/01/2022.
//

import Foundation
import CoreData
import RealmSwift

class BookmarksManager: DataPersistenceManager {
    
    // MARK: - Properties
    
    typealias DataPersistenceProviderType = RealmPersistenceProvider
    
    static let standard = BookmarksManager()
    let webServiceClient = GitHubClient()
    let dataPersistenceProvider = DataManager.standard.realmDataPersistenceProvider
    
    private var userBookmarks = Observable<Array<UserBookmark>>()
    private var repositoryBookmarks = Observable<Array<RepositoryBookmark>>()
    private var organizationBookmarks = Observable<Array<OrganizationBookmark>>()
    
    var activeBookmarksContext: BookmarksContext = .users
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Save and Load Methods
    
    func save() throws { }
    
    func load() throws {
        userBookmarks.value = dataPersistenceProvider.fetch()
        repositoryBookmarks.value = dataPersistenceProvider.fetch()
        organizationBookmarks.value = dataPersistenceProvider.fetch()
    }
    
    // MARK: - Write Methods
    
    @MainActor func add<Type: Model>(model: Type) throws {
        if !model.isComplete {
            if let userModel = model as? UserModel {
                Task {
                    var result: Result<Object,RealmError>?
                    if let completeUserModel = await getCompleteUser(with: userModel) {
                        result = dataPersistenceProvider.insert(completeUserModel)
                    }
                    switch result {
                    case .success(let object as UserBookmark): userBookmarks.value?.append(object)
                    default: return
                    }
                }
            } else if let repositoryModel = model as? RepositoryModel {
                Task {
                    var result: Result<Object,RealmError>?
                    if let completeRepositoryModel = await getCompleteRepository(with: repositoryModel) {
                        result = dataPersistenceProvider.insert(completeRepositoryModel)
                    }
                    switch result {
                    case .success(let object as RepositoryBookmark): repositoryBookmarks.value?.append(object)
                    default: return
                    }
                }
            } else if let organizationModel = model as? OrganizationModel {
                Task {
                    var result: Result<Object,RealmError>?
                    if let completeOrganizationModel = await getCompleteOrganization(with: organizationModel) {
                        result = dataPersistenceProvider.insert(completeOrganizationModel)
                    }
                    switch result {
                    case .success(let object as OrganizationBookmark): organizationBookmarks.value?.append(object)
                    default: return
                    }
                }
            }
        } else {
            let result = dataPersistenceProvider.insert(model)
            switch result {
            case .success(let object as UserBookmark): userBookmarks.value?.append(object)
            case .success(let object as RepositoryBookmark): repositoryBookmarks.value?.append(object)
            case .success(let object as OrganizationBookmark): organizationBookmarks.value?.append(object)
            case .failure(let realmError): throw realmError
            default: break
            }
        }
    }
    
    @MainActor func delete<T: Model>(model: T) throws {
        switch T.self {
        case is UserModel.Type: userBookmarks.value?.removeAll() { return $0.id == model.id }
        case is RepositoryModel.Type: repositoryBookmarks.value?.removeAll() { return $0.id == model.id }
        case is OrganizationModel.Type: organizationBookmarks.value?.removeAll() { return $0.id == model.id }
        default: break
        }
        try dataPersistenceProvider.delete(model)
    }
    
    @MainActor func clear<T: Model>(for modelType: T.Type) throws {
        switch modelType {
        case is UserModel.Type: userBookmarks.value?.removeAll()
                                try dataPersistenceProvider.deleteAll(UserBookmark.self)
        case is RepositoryModel.Type: repositoryBookmarks.value?.removeAll()
                                      try dataPersistenceProvider.deleteAll(RepositoryBookmark.self)
        case is OrganizationModel.Type: organizationBookmarks.value?.removeAll()
                                        try dataPersistenceProvider.deleteAll(OrganizationBookmark.self)
        default: break
        }
    }
    
    @MainActor func clearActive() throws {
        switch activeBookmarksContext {
        case .users: userBookmarks.value?.removeAll()
                     try dataPersistenceProvider.deleteAll(UserBookmark.self)
        case .repositories: repositoryBookmarks.value?.removeAll()
                            try dataPersistenceProvider.deleteAll(RepositoryBookmark.self)
        case .organizations: organizationBookmarks.value?.removeAll()
                             try dataPersistenceProvider.deleteAll(OrganizationBookmark.self)
        default: break
        }
    }
    
    @MainActor func clearAll() throws {
        try clear(for: UserModel.self)
        try clear(for: RepositoryModel.self)
        try clear(for: OrganizationModel.self)
    }
    
    // MARK: - Read Methods
    
    @MainActor func check<T: Model>(model: T) -> Bool? {
        switch T.self {
        case is UserModel.Type: return userBookmarks.value?.contains { return $0.id == model.id }
        case is RepositoryModel.Type: return repositoryBookmarks.value?.contains { return $0.id == model.id }
        case is OrganizationModel.Type: return organizationBookmarks.value?.contains { return $0.id == model.id }
        default: return nil
        }
    }
    
    // MARK: - Bind Methods
    
    func bindUsers(_ listener: @escaping (Array<UserBookmark>?) -> Void) {
        userBookmarks.bind(listener)
    }
    
    func bindRepositories(_ listener: @escaping (Array<RepositoryBookmark>?) -> Void) {
        repositoryBookmarks.bind(listener)
    }
    
    func bindOrganizations(_ listener: @escaping (Array<OrganizationBookmark>?) -> Void) {
        organizationBookmarks.bind(listener)
    }
    
    // MARK: - Completing Models Methods
    
    func getCompleteUser(with userModel: UserModel) async -> UserModel? {
        var user = try? await webServiceClient.fetchUser(userLogin: userModel.login).get()
        user?.isComplete = true
        return user
    }
    
    func getCompleteRepository(with repositoryModel: RepositoryModel) async -> RepositoryModel? {
        var repository = try? await webServiceClient.fetchRepository(fullName: repositoryModel.fullName).get()
        if let readmeData = try? await webServiceClient.downloadRepositoryREADME(fullName: repositoryModel.fullName, branch: repositoryModel.defaultBranch).get() {
            repository?.READMEString = String(data: readmeData, encoding: .utf8)
        }
        repository?.isComplete = true
        return repository
    }
    
    func getCompleteOrganization(with organizationModel: OrganizationModel) async -> OrganizationModel? {
        var organization = try? await webServiceClient.fetchOrganization(organizationLogin: organizationModel.login).get()
        organization?.isComplete = true
        return organization
    }
    
}
