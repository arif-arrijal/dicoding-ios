import CoreData
import RxSwift
import UIKit
import Core

protocol LocalDataSourceProtocol: AnyObject {
    func getProfile() -> Observable<UserEntity>
    func saveProfile(data: UserEntity) -> Observable<Bool>
    func findAll() -> Observable<[GameEntity]>
    func findOne(_ gameId: Int) -> Observable<GameEntity>
    func save(data: GameEntity) -> Observable<Bool>
    func delete(_ gameId: Int) -> Observable<Bool>
}

final class LocalDataSource: NSObject {
    typealias LocalDataSourceInstance = () -> LocalDataSource
    fileprivate let taskContext = DbUtil.newTaskContext()
    fileprivate let entityName = DbUtil.entityName

    static let sharedInstance: LocalDataSourceInstance = {
        return LocalDataSource()
    }
}

extension LocalDataSource: LocalDataSourceProtocol {
    func getProfile() -> Observable<UserEntity> {
        return Observable<UserEntity>.create { observer in
            Profile.synchronize()
            observer.onNext(UserEntity(name: Profile.name, email: Profile.email, phone: Profile.phone))
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func saveProfile(data: UserEntity) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            Profile.synchronize()
            if data.name.isEmpty {
                observer.onError(CustomError.nameMandatory)
            } else if data.phone.isEmpty {
                observer.onError(CustomError.phoneMandatory)
            } else if data.email.isEmpty {
                observer.onError(CustomError.emailMandatory)
            } else {
                Profile.name = data.name
                Profile.phone = data.phone
                Profile.email = data.email

                observer.onNext(true)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func findAll() -> Observable<[GameEntity]> {
        return Observable<[GameEntity]>.create { observer in
            self.taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
                do {
                    let results = try self.taskContext.fetch(fetchRequest)
                    var games: [GameEntity] = []
                    for result in results {
                        let game = GameEntity(
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
                    observer.onNext(games)
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func findOne(_ gameId: Int) -> Observable<GameEntity> {
        return Observable<GameEntity>.create { observer in
            self.taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DbUtil.entityName)
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
                do {
                    if let result = try self.taskContext.fetch(fetchRequest).first {
                        let game = GameEntity(
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
                        observer.onNext(game)
                        observer.onCompleted()
                    } else {
                        observer.onError(CustomError.dataNotFound)
                        observer.onCompleted()
                    }
                } catch let error as NSError {
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }

    }

    func save(data: GameEntity) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: self.taskContext) {
                    let member = NSManagedObject(entity: entity, insertInto: self.taskContext)
                    member.setValue(data.gameId, forKey: "gameId")
                    member.setValue(data.name, forKey: "name")
                    member.setValue(data.released, forKey: "released")
                    member.setValue(data.backgroundImage, forKey: "backgroundImage")
                    member.setValue(data.rating, forKey: "rating")
                    member.setValue(data.ratingTop, forKey: "ratingTop")
                    member.setValue(data.ratingsCount, forKey: "ratingsCount")
                    member.setValue(data.reviewsTextCount, forKey: "reviewsTextCount")
                    do {
                        try self.taskContext.save()
                        observer.onNext(true)
                        observer.onCompleted()
                    } catch let error as NSError {
                        observer.onError(error)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }

    func delete(_ gameId: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DbUtil.entityName)
                        fetchRequest.fetchLimit = 1
                        fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
                        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        batchDeleteRequest.resultType = .resultTypeCount
                if let batchDeleteResult = try? self.taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                    observer.onNext(batchDeleteResult.result != nil)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
