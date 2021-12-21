//
//  CoreDataManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/10/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let standard = CoreDataManager()
    
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    private var persistentContainer: NSPersistentContainer!
    
    private init() {}
    
    // MARK: - Main Methods
    
    func configure() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.overwrite
    }
    
    func save() -> CoreDataError? {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                return .saving(error)
            }
        }
        return nil
    }
    
    func load(completionHandler: ((CoreDataError?) -> Void)? = nil) {
        persistentContainer = NSPersistentContainer(name: "GitIt")
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                completionHandler?(.loading(error!))
                return
            }
            self.configure()
            completionHandler?(nil)
        }
    }
    
    // MARK: - Write Methods
    
    func insert<Type: Model>(_ model: Type) -> CoreDataError? {
        let mirror = Mirror(reflecting: model)
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
        let entityInstance = NSManagedObject(entity: entityDescription!, insertInto: viewContext)
        
        for child in mirror.children {
            if child.label == "description" {
                if case Optional<Any>.none = child.value {
                    entityInstance.setNilValueForKey("overview")
                } else {
                    entityInstance.setValue(child.value, forKey: "overview")
                }
            } else if child.label == "owner" {
                if case Optional<Any>.none = child.value {
                    entityInstance.setNilValueForKey("ownerLogin")
                    entityInstance.setNilValueForKey("ownerAvatarURL")
                } else {
                    let owner = child.value as! OwnerModel
                    entityInstance.setValue(owner.login, forKey: "ownerLogin")
                    entityInstance.setValue(owner.avatarURL, forKey: "ownerAvatarURL")
                }
            } else {
                if case Optional<Any>.none = child.value {
                    entityInstance.setNilValueForKey(child.label!)
                } else {
                    entityInstance.setValue(child.value, forKey: child.label!)
                }
            }
        }
        
        return save()
    }
    
    func delete<Type: Model>(_ model: Type) -> CoreDataError? {
        let fetchRequest = composeRequest(model)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
            return save()
        } catch {
            return .deleting(error)
        }
    }
    
    func delete<Entity: NSManagedObject>(_ object: Entity) -> CoreDataError? {
        let fetchRequest = composeRequest(object)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
            return save()
        } catch {
            return .deleting(error)
        }
    }
    
    func deleteAll<Entity: NSManagedObject>(_ entity: Entity.Type) -> CoreDataError? {
        let fetchRequest = composeRequest(entity)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object as! NSManagedObject)
            }
            return save()
        } catch let error {
            return .deleting(error)
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
    
}

extension CoreDataManager {
    
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
