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
    let context: NSManagedObjectContext

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func getAll<T: NSManagedObject>(entity: T.Type,
                                    predicate: NSPredicate? = nil,
                                    sortDescriptor: [NSSortDescriptor]? = nil) -> AnyPublisher<[T], Error> {

        Future {[context] promise in
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func delete<T: NSManagedObject>(entity: T.Type,
                                    predicate: NSPredicate) -> AnyPublisher<Void, Error> {
        Future {[context] promise in

            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = context
            privateMOC.perform {
                do {
                    guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                        promise(.failure(Failure.cacheError))
                        return
                    }
                    request.predicate = predicate
                    let objects = try privateMOC.fetch(request)

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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func add<T: NSManagedObject>(entity: T.Type, _ body: @escaping (inout T) -> Void) -> AnyPublisher<T, Error> {
        Future { [context] promise in

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
        .eraseToAnyPublisher()
    }

    func update<T: NSManagedObject>(entity: T.Type,
                                    predicate: NSPredicate,
                                    _ body: @escaping (inout T) -> Void) -> AnyPublisher<T, Error> {
        Future { [context] promise in

            context.performAndWait {
                do {
                    guard let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
                        return
                    }
                    request.predicate = predicate
                    var object = try context.fetch(request).first
                    if object != nil {

                        body(&object!)
                        try context.save()
                        promise(.success(object!))
                    } else {

                        promise(.failure(Failure.notFound))
                    }

                } catch {
                    promise(.failure(error))
                }
            }

        }
        .eraseToAnyPublisher()
    }

    func get<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate) -> AnyPublisher<T?, Error> {
        Future { [context] promise in

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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
