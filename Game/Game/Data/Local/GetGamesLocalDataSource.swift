import CoreData
import Core
import Combine
import Foundation

public struct GetGamesLocalDataSource: LocalDataSource {
    public typealias Request = Any

    public typealias Response = GameModuleEntity

    fileprivate let taskContext = DbUtil.newTaskContext()
    fileprivate let entityName = DbUtil.entityName

    public func list(request: Any?) -> AnyPublisher<[GameModuleEntity], Error> {
        return Future<[GameModuleEntity], Error> { completion in
            self.taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
                do {
                    let results = try self.taskContext.fetch(fetchRequest)
                    var games: [GameModuleEntity] = []
                    for result in results {
                        let game = GameModuleEntity(
                            gameId: result.value(forKey: "gameId") as? Int ?? 0,
                            name: result.value(forKey: "name") as? String ?? "",
                            released: result.value(forKey: "released") as? String ?? "",
                            backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                            rating: result.value(forKey: "rating") as? Double ?? 0.0,
                            ratingTop: result.value(forKey: "ratingTop") as? Int ?? 0,
                            ratingsCount: result.value(forKey: "ratingsCount") as? Int ?? 0,
                            reviewsTextCount: result.value(forKey: "reviewsTextCount") as? Int ?? 0,
                            ratings: nil,
                            description: nil,
                            genres: nil,
                            platforms: nil,
                            developers: nil,
                            publishers: nil,
                            tags: nil,
                            website: nil
                        )
                        games.append(game)
                    }
                    completion(.success(games))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func add(entities: GameModuleEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            self.taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: self.taskContext) {
                    let member = NSManagedObject(entity: entity, insertInto: self.taskContext)
                    member.setValue(entities.gameId, forKey: "gameId")
                    member.setValue(entities.name, forKey: "name")
                    member.setValue(entities.released, forKey: "released")
                    member.setValue(entities.backgroundImage, forKey: "backgroundImage")
                    member.setValue(entities.rating, forKey: "rating")
                    member.setValue(entities.ratingTop, forKey: "ratingTop")
                    member.setValue(entities.ratingsCount, forKey: "ratingsCount")
                    member.setValue(entities.reviewsTextCount, forKey: "reviewsTextCount")
                    do {
                        try self.taskContext.save()
                        completion(.success(true))
                    } catch let error as NSError {
                        completion(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    public func get(id: Int) -> AnyPublisher<GameModuleEntity, Error> {
        return Future<GameModuleEntity, Error> { completion in
            self.taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DbUtil.entityName)
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "gameId == \(id)")
                do {
                    if let result = try self.taskContext.fetch(fetchRequest).first {
                        let game = GameModuleEntity(
                            gameId: result.value(forKey: "gameId") as? Int ?? 0,
                            name: result.value(forKey: "name") as? String ?? "",
                            released: result.value(forKey: "released") as? String ?? "",
                            backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                            rating: result.value(forKey: "rating") as? Double ?? 0.0,
                            ratingTop: result.value(forKey: "ratingTop") as? Int ?? 0,
                            ratingsCount: result.value(forKey: "ratingsCount") as? Int ?? 0,
                            reviewsTextCount: result.value(forKey: "reviewsTextCount") as? Int ?? 0,
                            ratings: nil,
                            description: nil,
                            genres: nil,
                            platforms: nil,
                            developers: nil,
                            publishers: nil,
                            tags: nil,
                            website: nil
                        )
                        completion(.success(game))
                    } else {
                        completion(.failure(CustomError.dataNotFound))
                    }
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func update(id: Int, entity: GameModuleEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    public func delete(id: Int) -> AnyPublisher<Bool, Error> {
            return Future<Bool, Error> { completion in
                self.taskContext.perform {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DbUtil.entityName)
                            fetchRequest.fetchLimit = 1
                            fetchRequest.predicate = NSPredicate(format: "gameId == \(id)")
                            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            batchDeleteRequest.resultType = .resultTypeCount
                    if let batchDeleteResult = try? self.taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                        completion(.success(batchDeleteResult.result != nil))
                    }
                }
            }.eraseToAnyPublisher()
    }
}
