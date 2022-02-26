//
//  CoreDataClient.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine
import CoreData

final class CoreDataClient {
    var context: NSManagedObjectContext?

    func getAll<T: NSManagedObject>( predicate: NSPredicate? = nil,
                                     sortDescriptor: [NSSortDescriptor]? = nil) -> AnyPublisher<[T], Error> {
        Deferred { [context] in
            Future { promise in

                guard let context = context else {

                    promise(.failure(Failure.cacheError))
                    return
                }
                context.performAndWait {
                    do {
                        guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {

                            promise(.failure(Failure.cacheError))
                            return
                        }

                        request.predicate = predicate
                        request.sortDescriptors = sortDescriptor
                        let values = try context.fetch(request)

                        promise(.success(values))
                    } catch {
                        promise(.failure(Failure.cacheError))
                    }
                }
            }

        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func deleteObject<T: NSManagedObject>(entity: T.Type,
                                          predicate: NSPredicate) -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                guard let context = context  else {
                    promise(.failure(Failure.cacheError))
                    return
                }
                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateMOC.parent = context
                privateMOC.perform {
                    do {
                        guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                            promise(.failure(Failure.cacheError))
                            return
                        }
                        request.predicate = predicate
                        let objects = try context.fetch(request)

                        objects.forEach { object in
                            privateMOC.delete(object)
                        }

                        try privateMOC.save()
                        context.performAndWait {
                            do {
                                try context.save()
                                promise(.success(()))
                            } catch {
                                promise(.failure(Failure.cacheError))
                            }
                        }
                    } catch {
                        promise(.failure(Failure.cacheError))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

    }

    func add<T: NSManagedObject>(_ body: @escaping (inout T) -> Void) -> AnyPublisher<T, Error> {
        Deferred { [context] in
            Future { promise in
                guard let context = context  else {
                    promise(.failure(Failure.cacheError))
                    return
                }
                context.perform {
                    var object = T(context: context)
                    body(&object)
                    do {
                        try context.save()
                        promise(.success(object))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func get<T: NSManagedObject>(predicate: NSPredicate) -> AnyPublisher<T?, Error> {
        Deferred { [context] in
            Future { promise in

                guard let context = context else {

                    promise(.failure(Failure.cacheError))
                    return

                }
                context.performAndWait {
                    do {
                        guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                            return
                        }
                        request.predicate = predicate
                        let  object = try context.fetch(request).first

                        promise(.success(object))
                    } catch {
                        promise(.failure(error))
                    }
                }

            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
