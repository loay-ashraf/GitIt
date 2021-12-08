//
//  DataController.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/10/2021.
//

import Foundation
import CoreData

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
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    // MARK: - Core Data Saving support

    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
            }
        }
    }
    
    func exists<Type: Model>(_ model: Type) -> Bool {
        let id = model.id
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %ld", id as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let count = try self.viewContext.count(for: fetchRequest)
            return count > 0 ? true : false
        } catch let error {
            print("\(model) with id: \(String(describing: id)) error :", error)
            return false
        }
    }
    
    func fetchSync<Entity: NSManagedObject>(entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil) -> [Any]? {
        let fetchRequest = entity.fetchRequest()
        if sortKey != nil, ascending != nil {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending!)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        let results = try? viewContext.fetch(fetchRequest)
        return results
    }
    
    func fetch<Entity: NSManagedObject>(entity: Entity.Type, sortKey: String? = nil, ascending: Bool? = nil, completion: @escaping ([NSFetchRequestResult]?) -> Void) {
        let fetchRequest = entity.fetchRequest()
        if sortKey != nil, ascending != nil {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending!)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            if let result = result.finalResult {
                completion(result)
            }
        }
        _ = try? viewContext.execute(asynchronousFetchRequest)
    }
    
    func insert<Type: Model>(_ model: Type) {
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
        
        save()
    }
    
    func delete<Type: Model>(_ model: Type) {
        let id = model.id
        let typeName = String(describing: Type.self)
        let entityName = typeName.replacingOccurrences(of: "Model", with: "")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %ld", id as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            for object in results {
                guard object != nil else { continue }
                self.viewContext.delete(object as! NSManagedObject)
                self.save()
            }
        } catch let error {
            print("Deleting \(model) with id: \(String(describing: id)) error :", error)
        }
    }
    
    func delete<Entity: NSManagedObject>(_ object: Entity) {
        let objectType = type(of: object)
        let id = object.value(forKey: "id") as! Int32
        let fetchRequest = objectType.fetchRequest()
        let predicate = NSPredicate(format: "id == %ld", id)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            for object in results {
                guard object != nil else { continue }
                self.viewContext.delete(object as! NSManagedObject)
                self.save()
            }
        } catch let error {
            print("Deleting all data in \(object) with id: \(id) error :", error)
        }
    }
    
    func deleteAll<Entity: NSManagedObject>(_ entity: Entity.Type) {
        let fetchRequest = entity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            for object in results {
                guard object != nil else { continue }
                self.viewContext.delete(object as! NSManagedObject)
                self.save()
            }
        } catch let error {
            print("Deleting all data in \(entity) error :", error)
        }
    }
    
}
