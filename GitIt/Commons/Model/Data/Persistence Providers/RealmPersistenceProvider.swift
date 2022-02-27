//
//  RealmPersistenceProvider.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/02/2022.
//

import Foundation
import RealmSwift

class RealmPersistenceProvider: DataPersistenceProvider {
    
    // MARK: - Properties
    
    var realm: Realm { return try! Realm() }
    
    // MARK: - Write Methods
    
    func insert<T: Model>(_ model: T) -> Result<Object,RealmError> {
        var newObject: Object!
        switch model {
        case let userModel as UserModel: newObject = UserBookmark(form: userModel)
        case let repositoryModel as RepositoryModel: newObject = RepositoryBookmark(from: repositoryModel)
        case let organizationModel as OrganizationModel: newObject = OrganizationBookmark(from: organizationModel)
        default: return .failure(.unsupportedModelType)
        }
        do {
            try realm.write { realm.add(newObject) }
        } catch  {
            return .failure(.writing(error))
        }
        return .success(newObject)
    }
    
    func insert<T: Object>(_ newObject: T) throws {
        do {
            try realm.write { realm.add(newObject) }
        } catch  {
            throw RealmError.writing(error)
        }
    }
    
    func delete<T: Model>(_ model: T) throws {
        var objectToDelete: Object!
        switch model {
        case let userModel as UserModel: objectToDelete = realm.object(ofType: UserBookmark.self, forPrimaryKey: userModel.id)
        case let repositoryModel as RepositoryModel: objectToDelete = realm.object(ofType: RepositoryBookmark.self, forPrimaryKey: repositoryModel.id)
        case let organizationModel as OrganizationModel: objectToDelete = realm.object(ofType: OrganizationBookmark.self, forPrimaryKey: organizationModel.id)
        default: throw RealmError.unsupportedModelType
        }
        do {
            try realm.write { realm.delete(objectToDelete) }
        } catch  {
            throw RealmError.deleting(error)
        }
    }
    
    func delete<T: Object>(_ object: T) throws {
        do {
            try realm.write { realm.delete(object) }
        } catch  {
            throw RealmError.deleting(error)
        }
    }
    
    func deleteAll<T: Object>(_ objectType: T.Type) throws {
        let objectsToDelete = realm.objects(objectType)
        do {
            try realm.write { realm.delete(objectsToDelete) }
        } catch  {
            throw RealmError.deleting(error)
        }
    }
    
    // MARK: - Read Methods

    func exists<T: Model>(_ model: T) -> Result<Bool,RealmError> {
        switch model {
        case let userModel as UserModel: return realm.object(ofType: UserBookmark.self, forPrimaryKey: userModel.id) != nil ? .success(true) : .success(false)
        case let repositoryModel as RepositoryModel: return realm.object(ofType: RepositoryBookmark.self, forPrimaryKey: repositoryModel.id) != nil ? .success(true) : .success(false)
        case let organizationModel as OrganizationModel: return realm.object(ofType: OrganizationBookmark.self, forPrimaryKey: organizationModel.id) != nil ? .success(true) : .success(false)
        default: return .failure(.unsupportedModelType)
        }
    }
    
    func exists<T: Object>(_ object: T) -> Bool {
        return realm.object(ofType: T.self, forPrimaryKey: object.objectSchema.primaryKeyProperty) != nil ? true : false
    }
    
    func fetch<T: Object>(query: RealmQuery<T>? = nil) -> Array<T> {
        var objects: Results<T>
        if let query = query {
            objects = realm.objects(T.self).where(query)
        } else {
            objects = realm.objects(T.self)
        }
        return Array(objects)
    }
    
    // MARK: Clear Methods
    
    func clear() throws {
        do {
            try realm.write { realm.deleteAll() }
        } catch  {
            throw RealmError.deleting(error)
        }
    }
    
}
