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
    
    private var userBookmarks: [User]?
    private var repositoryBookmarks: [Repository]?
    private var organizationBookmarks: [Organization]?
    
    // MARK: - Initialisation
    
    private init() {}
    
    // MARK: - Main Methods
    
    func saveBookmarks() -> CoreDataError? {
        return CoreDataManager.standard.save()
    }
    
    func loadBookmarks() -> CoreDataError? {
        do {
            userBookmarks = try CoreDataManager.standard.fetchSync(entity: User.self, sortKey: nil, ascending: true).get()
            repositoryBookmarks = try CoreDataManager.standard.fetchSync(entity: Repository.self, sortKey: nil, ascending: true).get()
            organizationBookmarks = try CoreDataManager.standard.fetchSync(entity: Organization.self, sortKey: nil, ascending: true).get()
        } catch {
            return error as? CoreDataError
        }
        return nil
    }
    
    // MARK: - Write Methods
    
    func addBookmark<Type: Model>(model: Type) -> CoreDataError? {
        if !model.isComplete {
            if let userModel = model as? UserModel {
                getCompleteUser(with: userModel) { completeUserModel in
                    var result: Result<NSManagedObject,CoreDataError>?
                    if let completeUserModel = completeUserModel {
                       result = CoreDataManager.standard.insert(completeUserModel)
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
                       result = CoreDataManager.standard.insert(completeRepositoryModel)
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
                       result = CoreDataManager.standard.insert(completeOrganizationModel)
                    }
                    switch result {
                    case .success(let managedObject): self.organizationBookmarks?.append(managedObject as! Organization)
                    case .failure: return
                    case .none: return
                    }
                }
            }
            return nil
        } else {
            let result = CoreDataManager.standard.insert(model)
            switch result {
            case let .success(managedObject) where managedObject.self is User: userBookmarks?.append(managedObject as! User)
            case let .success(managedObject) where managedObject.self is Repository: repositoryBookmarks?.append(managedObject as! Repository)
            case let .success(managedObject) where managedObject.self is Organization: organizationBookmarks?.append(managedObject as! Organization)
            case .failure(let coreDataError): return coreDataError
            default: break
            }
            return nil
        }
    }
    
    func deleteBookmark<Type: Model>(model: Type) -> CoreDataError? {
        switch Type.self {
        case is UserModel.Type: userBookmarks?.removeAll() { return $0.id == model.id }
        case is RepositoryModel.Type: repositoryBookmarks?.removeAll() { return $0.id == model.id }
        case is OrganizationModel.Type: organizationBookmarks?.removeAll() { return $0.id == model.id }
        default: break
        }
        return CoreDataManager.standard.delete(model)
    }
    
    func clearBookmarks<Type: Model>(for modelType: Type.Type) -> CoreDataError? {
        switch modelType {
        case is UserModel.Type: return CoreDataManager.standard.deleteAll(User.self)
        case is RepositoryModel.Type: return CoreDataManager.standard.deleteAll(Repository.self)
        case is OrganizationModel.Type: return CoreDataManager.standard.deleteAll(Organization.self)
        default: return nil
        }
    }
    
    func clearAllBookmarks() -> CoreDataError? {
        let userError = CoreDataManager.standard.deleteAll(User.self)
        let repositoryError = CoreDataManager.standard.deleteAll(Repository.self)
        let organizationError = CoreDataManager.standard.deleteAll(Organization.self)
        if userError != nil {
            return userError
        } else if repositoryError != nil {
            return repositoryError
        } else if organizationError != nil {
            return organizationError
        }
        return nil
    }
    
    // MARK: - Read Methods
    
    func checkBookmark<Type: Model>(model: Type) -> Bool? {
        switch Type.self {
        case is UserModel.Type: return userBookmarks?.contains() { return $0.id == model.id }
        case is RepositoryModel.Type: return repositoryBookmarks?.contains() { return $0.id == model.id }
        case is OrganizationModel.Type: return organizationBookmarks?.contains() { return $0.id == model.id }
        default: return nil
        }
    }
    
    func getUserBookmarks() -> [User]? {
        return userBookmarks
    }
    
    func getRepositoryBookmarks() -> [Repository]? {
        return repositoryBookmarks
    }
    
    func getOrganizationBookmarks() -> [Organization]? {
        return organizationBookmarks
    }
    
    // MARK: - Completing Models Methods
    
    func getCompleteUser(with userModel: UserModel, then handler: @escaping (UserModel?) -> Void) {
        NetworkClient.standard.getUser(userLogin: userModel.login) { result in
            switch result {
            case .success(var response): response.isComplete = true
                                         handler(response)
            case .failure: handler(nil)
            }
        }
    }
    
    func getCompleteRepository(with repositoryModel: RepositoryModel, then handler: @escaping (RepositoryModel?) -> Void) {
        NetworkClient.standard.getRepository(fullName: repositoryModel.fullName) { result in
            switch result {
            case .success(var response): NetworkClient.standard.getRepositoryReadme(fullName: response.fullName, branch: response.defaultBranch) { result in
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
        NetworkClient.standard.getOrganization(organizationLogin: organizationModel.login) { result in
            switch result {
            case .success(var response): response.isComplete = true
                                         handler(response)
            case .failure: handler(nil)
            }
        }
    }
    
}
