//
//  BookmarksManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/01/2022.
//

import Foundation
import CoreData

class BookmarksManager: DataPersistenceManager {
    
    // MARK: - Properties
    
    typealias DataPersistenceProviderType = CoreDataPersistenceProvider
    
    static let standard = BookmarksManager()
    let webServiceClient = GitHubClient()
    let dataPersistenceProvider = DataManager.standard.coreDataPersistenceProvider
    
    private var userBookmarks = Observable<Array<User>>()
    private var repositoryBookmarks = Observable<Array<Repository>>()
    private var organizationBookmarks = Observable<Array<Organization>>()
    
    var activeBookmarksContext: BookmarksContext = .users
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Save and Load Methods
    
    func save() throws {
        try dataPersistenceProvider.saveContexts()
    }
    
    func load() throws {
        userBookmarks.value = try dataPersistenceProvider.fetchSync(entity: User.self, sortKey: nil, ascending: true).get()
        repositoryBookmarks.value = try dataPersistenceProvider.fetchSync(entity: Repository.self, sortKey: nil, ascending: true).get()
        organizationBookmarks.value = try dataPersistenceProvider.fetchSync(entity: Organization.self, sortKey: nil, ascending: true).get()
    }
    
    // MARK: - Write Methods
    
    func add<Type: Model>(model: Type) throws {
        if !model.isComplete {
            if let userModel = model as? UserModel {
                Task {
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeUserModel = await getCompleteUser(with: userModel) {
                        result = dataPersistenceProvider.insert(completeUserModel)
                    }
                    switch result {
                    case .success(let managedObject): userBookmarks.value?.append(managedObject as! User)
                    case .failure: return
                    case .none: return
                    }
                }
            } else if let repositoryModel = model as? RepositoryModel {
                Task {
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeRepositoryModel = await getCompleteRepository(with: repositoryModel) {
                        result = dataPersistenceProvider.insert(completeRepositoryModel)
                    }
                    switch result {
                    case .success(let managedObject): repositoryBookmarks.value?.append(managedObject as! Repository)
                    case .failure: return
                    case .none: return
                    }
                }
            } else if let organizationModel = model as? OrganizationModel {
                Task {
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeOrganizationModel = await getCompleteOrganization(with: organizationModel) {
                        result = dataPersistenceProvider.insert(completeOrganizationModel)
                    }
                    switch result {
                    case .success(let managedObject): organizationBookmarks.value?.append(managedObject as! Organization)
                    case .failure: return
                    case .none: return
                    }
                }
            }
        } else {
            let result = dataPersistenceProvider.insert(model)
            switch result {
            case let .success(managedObject) where managedObject.self is User: userBookmarks.value?.append(managedObject as! User)
            case let .success(managedObject) where managedObject.self is Repository: repositoryBookmarks.value?.append(managedObject as! Repository)
            case let .success(managedObject) where managedObject.self is Organization: organizationBookmarks.value?.append(managedObject as! Organization)
            case .failure(let coreDataError): throw coreDataError
            default: break
            }
        }
    }
    
    func delete<Type: Model>(model: Type) throws {
        switch Type.self {
        case is UserModel.Type: userBookmarks.value?.removeAll() { return $0.id == model.id }
        case is RepositoryModel.Type: repositoryBookmarks.value?.removeAll() { return $0.id == model.id }
        case is OrganizationModel.Type: organizationBookmarks.value?.removeAll() { return $0.id == model.id }
        default: break
        }
        try dataPersistenceProvider.delete(model)
    }
    
    func clear<Type: Model>(for modelType: Type.Type) throws {
        switch modelType {
        case is UserModel.Type: userBookmarks.value?.removeAll()
                                try dataPersistenceProvider.deleteAll(User.self)
        case is RepositoryModel.Type: repositoryBookmarks.value?.removeAll()
                                      try dataPersistenceProvider.deleteAll(Repository.self)
        case is OrganizationModel.Type: organizationBookmarks.value?.removeAll()
                                        try dataPersistenceProvider.deleteAll(Organization.self)
        default: break
        }
    }
    
    func clearActive() throws {
        switch activeBookmarksContext {
        case .users: userBookmarks.value?.removeAll()
                     try dataPersistenceProvider.deleteAll(User.self)
        case .repositories: repositoryBookmarks.value?.removeAll()
                            try dataPersistenceProvider.deleteAll(Repository.self)
        case .organizations: organizationBookmarks.value?.removeAll()
                             try dataPersistenceProvider.deleteAll(Organization.self)
        default: break
        }
    }
    
    func clearAll() throws {
        try clear(for: UserModel.self)
        try clear(for: RepositoryModel.self)
        try clear(for: OrganizationModel.self)
    }
    
    // MARK: - Read Methods
    
    func check<Type: Model>(model: Type) -> Bool? {
        switch Type.self {
        case is UserModel.Type: return userBookmarks.value?.contains { return $0.id == model.id }
        case is RepositoryModel.Type: return repositoryBookmarks.value?.contains { return $0.id == model.id }
        case is OrganizationModel.Type: return organizationBookmarks.value?.contains { return $0.id == model.id }
        default: return nil
        }
    }
    
    // MARK: - Bind Methods
    
    func bindUsers(_ listener: @escaping (Array<User>?) -> Void) {
        userBookmarks.bind(listener)
    }
    
    func bindRepositories(_ listener: @escaping (Array<Repository>?) -> Void) {
        repositoryBookmarks.bind(listener)
    }
    
    func bindOrganizations(_ listener: @escaping (Array<Organization>?) -> Void) {
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
