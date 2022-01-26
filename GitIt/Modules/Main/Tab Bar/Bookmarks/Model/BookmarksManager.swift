//
//  BookmarksManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/01/2022.
//

import Foundation
import CoreData

class BookmarksManager {
    
    static let standard = BookmarksManager()
    let coreDataHelper = DataManager.standard.coreDataHelper
    
    private var userBookmarks: [User]?
    private var repositoryBookmarks: [Repository]?
    private var organizationBookmarks: [Organization]?
    
    var activeBookmarksContext: BookmarksContext!
    
    // MARK: - Initialisation
    
    private init() {}
    
    // MARK: - Save and Load Methods
    
    func save() throws {
        try coreDataHelper.saveContexts()
    }
    
    func load() throws {
        userBookmarks = try coreDataHelper.fetchSync(entity: User.self, sortKey: nil, ascending: true).get()
        repositoryBookmarks = try coreDataHelper.fetchSync(entity: Repository.self, sortKey: nil, ascending: true).get()
        organizationBookmarks = try coreDataHelper.fetchSync(entity: Organization.self, sortKey: nil, ascending: true).get()
    }
    
    // MARK: - Write Methods
    
    func add<Type: Model>(model: Type) throws {
        if !model.isComplete {
            if let userModel = model as? UserModel {
                getCompleteUser(with: userModel) { completeUserModel in
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeUserModel = completeUserModel {
                        result = self.coreDataHelper.insert(completeUserModel)
                    }
                    switch result {
                    case .success(let managedObject): self.userBookmarks?.append(managedObject as! User)
                    case .failure: return
                    case .none: return
                    }
                }
            } else if let repositoryModel = model as? RepositoryModel {
                getCompleteRepository(with: repositoryModel) { completeRepositoryModel in
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeRepositoryModel = completeRepositoryModel {
                        result = self.coreDataHelper.insert(completeRepositoryModel)
                    }
                    switch result {
                    case .success(let managedObject): self.repositoryBookmarks?.append(managedObject as! Repository)
                    case .failure: return
                    case .none: return
                    }
                }
            } else if let organizationModel = model as? OrganizationModel {
                getCompleteOrganization(with: organizationModel) { completeOrganizationModel in
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeOrganizationModel = completeOrganizationModel {
                        result = self.coreDataHelper.insert(completeOrganizationModel)
                    }
                    switch result {
                    case .success(let managedObject): self.organizationBookmarks?.append(managedObject as! Organization)
                    case .failure: return
                    case .none: return
                    }
                }
            }
        } else {
            let result = coreDataHelper.insert(model)
            switch result {
            case let .success(managedObject) where managedObject.self is User: userBookmarks?.append(managedObject as! User)
            case let .success(managedObject) where managedObject.self is Repository: repositoryBookmarks?.append(managedObject as! Repository)
            case let .success(managedObject) where managedObject.self is Organization: organizationBookmarks?.append(managedObject as! Organization)
            case .failure(let coreDataError): throw coreDataError
            default: break
            }
        }
    }
    
    func delete<Type: Model>(model: Type) throws {
        switch Type.self {
        case is UserModel.Type: userBookmarks?.removeAll() { return $0.id == model.id }
        case is RepositoryModel.Type: repositoryBookmarks?.removeAll() { return $0.id == model.id }
        case is OrganizationModel.Type: organizationBookmarks?.removeAll() { return $0.id == model.id }
        default: break
        }
        try coreDataHelper.delete(model)
    }
    
    func clear<Type: Model>(for modelType: Type.Type) throws {
        switch modelType {
        case is UserModel.Type: userBookmarks?.removeAll()
                                try coreDataHelper.deleteAll(User.self)
        case is RepositoryModel.Type: repositoryBookmarks?.removeAll()
                                      try coreDataHelper.deleteAll(Repository.self)
        case is OrganizationModel.Type: organizationBookmarks?.removeAll()
                                        try coreDataHelper.deleteAll(Organization.self)
        default: break
        }
    }
    
    func clearActive() throws {
        switch activeBookmarksContext {
        case .users: userBookmarks?.removeAll()
                     try coreDataHelper.deleteAll(User.self)
        case .repositories: repositoryBookmarks?.removeAll()
                            try coreDataHelper.deleteAll(Repository.self)
        case .organizations: organizationBookmarks?.removeAll()
                             try coreDataHelper.deleteAll(Organization.self)
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
        case is UserModel.Type: return userBookmarks?.contains() { return $0.id == model.id }
        case is RepositoryModel.Type: return repositoryBookmarks?.contains() { return $0.id == model.id }
        case is OrganizationModel.Type: return organizationBookmarks?.contains() { return $0.id == model.id }
        default: return nil
        }
    }
    
    func getUsers() -> [User]? {
        return userBookmarks
    }
    
    func getRepositories() -> [Repository]? {
        return repositoryBookmarks
    }
    
    func getOrganizations() -> [Organization]? {
        return organizationBookmarks
    }
    
    // MARK: - Completing Models Methods
    
    func getCompleteUser(with userModel: UserModel, then handler: @escaping (UserModel?) -> Void) {
        GitHubClient.fetchUser(userLogin: userModel.login) { result in
            switch result {
            case .success(var response): response.isComplete = true
                                         handler(response)
            case .failure: handler(nil)
            }
        }
    }
    
    func getCompleteRepository(with repositoryModel: RepositoryModel, then handler: @escaping (RepositoryModel?) -> Void) {
        GitHubClient.fetchRepository(fullName: repositoryModel.fullName) { result in
            switch result {
            case .success(var response): GitHubClient.downloadRepositoryREADME(fullName: response.fullName, branch: response.defaultBranch) { result in
                switch result {
                case .success(let readMeString): response.READMEString = String(data: readMeString, encoding: .utf8)
                                                 response.isComplete = true
                                                 handler(response)
                case .failure: handler(nil)
                }
            }
            case .failure: handler(nil)
            }
        }
    }
    
    func getCompleteOrganization(with organizationModel: OrganizationModel, then handler: @escaping (OrganizationModel?) -> Void) {
        GitHubClient.fetchOrganization(organizationLogin: organizationModel.login) { result in
            switch result {
            case .success(var response): response.isComplete = true
                                         handler(response)
            case .failure: handler(nil)
            }
        }
    }
    
}
