//
//  CoreDataHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/10/2021.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    private var persistentContainer: NSPersistentContainer!
    private var viewContext: NSManagedObjectContext! { return persistentContainer?.viewContext }
    
    // MARK: - Main Methods
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.overwrite
    }
    
    func saveContexts() throws {
        if persistentContainer != nil, viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                throw CoreDataError.saving(error)
            }
        }
    }
    
    func setup(completionHandler: ((CoreDataError?) -> Void)? = nil) {
        persistentContainer = NSPersistentContainer(name: "GitIt")
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                completionHandler?(.loading(error!))
                return
            }
            self.configureContexts()
            completionHandler?(nil)
        }
    }
    
    // MARK: - Write Methods
    
    func insert<Type: Model>(_ model: Type) -> Result<NSManagedObject,CoreDataError> {
        var newManagedObject: NSManagedObject!
        switch Type.self {
        case is UserModel.Type: newManagedObject = User(form: model as! UserModel, in: viewContext)
        case is RepositoryModel.Type: newManagedObject = Repository(from: model as! RepositoryModel, in: viewContext)
        case is OrganizationModel.Type: newManagedObject = Organization(from: model as! OrganizationModel, in: viewContext)
        default: break
        }
        return .success(newManagedObject)
    }
    
    func delete<Type: Model>(_ model: Type) throws {
        let fetchRequest = composeRequest(model)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
        } catch {
            throw CoreDataError.deleting(error)
        }
    }
    
    func delete<Entity: NSManagedObject>(_ object: Entity) throws {
        let fetchRequest = composeRequest(object)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
        } catch {
            throw CoreDataError.deleting(error)
        }
    }
    
    func deleteAll<Entity: NSManagedObject>(_ entity: Entity.Type) throws {
        let fetchRequest = composeRequest(entity)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
        } catch {
            throw CoreDataError.deleting(error)
        }
    }
    
    // MARK: - Read Methods

    func exists<Type: Model>(_ model: Type) -> Result<Bool,CoreDataError> {
        let fetchRequest = composeRequest(model)
        do {
            let count = try self.viewContext.count(for: fetchRequest)
            return count > 0 ? .success(true) : .success(false)
        } catch let error {
            return .failure(.fetching(error))
        }
    }
    
    func fetchSync<Entity: NSManagedObject>(entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil) -> Result<[Entity],CoreDataError> {
        let fetchRequest = composeRequest(entity)
        do {
            if let results = try viewContext.fetch(fetchRequest) as? [Entity] {
                return .success(results)
            } else {
                return .failure(.noData)
            }
        } catch {
            return .failure(.fetching(error))
        }
    }
    
    func fetch<Entity: NSManagedObject>(entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil, completion: @escaping (Result<[Entity],CoreDataError>) -> Void) {
        let fetchRequest = composeRequest(entity)
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            if let result = result.finalResult as? [Entity] {
                completion(.success(result))
            } else {
                completion(.failure(.noData))
            }
        }
        do {
            _ = try viewContext.execute(asynchronousFetchRequest)
        } catch {
            completion(.failure(.fetching(error)))
        }
    }
    
    // MARK: Clear Methods
    
    func clear() throws {
        let storeCoordinator = persistentContainer.persistentStoreCoordinator
        // Delete each existing persistent store
        for store in storeCoordinator.persistentStores {
            try storeCoordinator.destroyPersistentStore( at: store.url!, ofType: store.type, options: nil)
        }
        persistentContainer = nil
    }
    
}

extension CoreDataHelper {
    
    // MARK: - Fetch Request Helper Methods
    
    private func composeRequest<Entity: NSManagedObject>(_ entity: Entity.Type) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = entity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    private func composeRequest<Entity: NSManagedObject>(_ entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = entity.fetchRequest()
        if sortKey != nil, ascending != nil {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending!)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        return fetchRequest
    }
    
    private func composeRequest<Entity: NSManagedObject>(_ object: Entity) -> NSFetchRequest<NSFetchRequestResult> {
        let objectType = type(of: object)
        let id = object.value(forKey: "id") as! Int32
        let fetchRequest = objectType.fetchRequest()
        let predicate = NSPredicate(format: "id == %ld", id)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    private func composeRequest<Type: Model>(_ model: Type) -> NSFetchRequest<NSFetchRequestResult> {
        let id = model.id
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %ld", id as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
}
