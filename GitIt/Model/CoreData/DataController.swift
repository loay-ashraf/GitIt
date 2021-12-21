//
//  DataController.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/10/2021.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case saving(Error)
    case loading(Error)
    case fetching(Error)
    case deleting(Error)
    case noData
}

class DataController {
    
    static let standard = DataController()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GitIt")
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.overwrite
    }
    
    func load(completion: ((CoreDataError?) -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                completion?(.loading(error!))
                return
            }
            self.configureContexts()
            completion?(nil)
        }
    }
    
    // MARK: - Core Data Saving support

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
    
    func exists<Type: Model>(_ model: Type) -> Result<Bool,CoreDataError> {
        let id = model.id
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %ld", id as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let count = try self.viewContext.count(for: fetchRequest)
            return count > 0 ? .success(true) : .success(false)
        } catch let error {
            return .failure(.fetching(error))
        }
    }
    
    func fetchSync<Entity: NSManagedObject>(entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil) -> Result<[Entity],CoreDataError> {
        let fetchRequest = entity.fetchRequest()
        if sortKey != nil, ascending != nil {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending!)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
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
        let fetchRequest = entity.fetchRequest()
        if sortKey != nil, ascending != nil {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending!)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
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
        let id = model.id
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %ld", id as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
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
        let objectType = type(of: object)
        let id = object.value(forKey: "id") as! Int32
        let fetchRequest = objectType.fetchRequest()
        let predicate = NSPredicate(format: "id == %ld", id)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
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
        let fetchRequest = entity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
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
    
}
