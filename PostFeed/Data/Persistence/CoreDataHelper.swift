//
//  CoreDataHelper.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import CoreData
import Foundation

final class CoreDataHelper {
    static let shared = CoreDataHelper()
    private var context: NSManagedObjectContext?

    func setContext( _ context: NSManagedObjectContext?) {
        self.context = context
    }

    /// Get all values from an entity
    static func getAll<T: NSManagedObject>( predicate: NSPredicate? = nil,
                                            sortDescriptor: [NSSortDescriptor]? = nil,
                                            completion: @escaping(([T]?) -> Void)) {
        guard let context = CoreDataHelper.shared.context else {
            completion(nil)
            return
        }
        context.performAndWait {
            do {
                guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                    completion(nil)
                    return
                }

                request.predicate = predicate
                request.sortDescriptors = sortDescriptor
                let values = try context.fetch(request)
                completion(values)
            } catch {
                completion(nil)
            }
        }
    }

    /// Remove object
    static func deleteObject(_ object: NSManagedObject, completion: @escaping ((Bool) -> Void)) {
        guard let context = CoreDataHelper.shared.context  else {
            completion(false)
            return
        }
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        privateMOC.perform {
            do {
                let managedObject = privateMOC.object(with: object.objectID)
                privateMOC.delete(managedObject)

                try privateMOC.save()
                context.performAndWait {
                    do {
                        try context.save()
                        completion(true)
                    } catch {
                        completion(true)
                    }
                }
            } catch {
                completion(true)
            }
        }
    }

    /// Get main context Attachment
    static func getMainContextObject<T: NSManagedObject>(_ entity: T) -> T? {
        var managedObject: T?
        guard let context = CoreDataHelper.shared.context else { return nil }
        context.performAndWait {
            managedObject = context.object(with: entity.objectID) as? T
        }
        return managedObject
    }

    /// Get main context Attachment
    static func getMainContextObjectBy<T: NSManagedObject>(predicate: NSPredicate) -> T? {
        var managedObject: T?
        guard let context = CoreDataHelper.shared.context else { return nil }
        context.performAndWait {
            do {
                guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                    return
                }
                request.predicate = predicate
                managedObject = try context.fetch(request).first
            } catch {
            }
        }
        return managedObject
    }

    /// Purge Entity
    static func purge<T: NSManagedObject>(entity: T.Type, completion: @escaping((Bool) -> Void)) {
        guard let context = CoreDataHelper.shared.context else { return }
        context.performAndWait {
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
                guard let objects = try context.fetch(request) as? [T] else {
                    completion(false)
                    return
                }
                objects.forEach {
                    context.delete($0)
                }
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    /// Get main context Attachment
    static func getMainContextObjects<T: NSManagedObject>(predicate: NSPredicate? = nil,
                                                          sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        var managedObject: [T]?
        guard let context = CoreDataHelper.shared.context else { return nil }
        context.performAndWait {
            do {
                guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                    return
                }
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                managedObject = try context.fetch(request)
            } catch {
            }
        }
        return managedObject
    }
}
