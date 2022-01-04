//
//  BookmarksManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/01/2022.
//

import Foundation

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
    
}
