import Foundation
import RxSwift

protocol GameRepositoryProtocol {
    func findAll(query: String?, pageUrl: String?) -> Observable<[GameModel]>
    func findOne(gameId: Int) -> Observable<GameModel>
    func findAllSaved(query: String?) -> Observable<[GameModel]>
    func findOneSaved(gameId: Int) -> Observable<GameModel>
    func save(data: GameModel) -> Observable<Bool>
    func delete(_ gameId: Int) -> Observable<Bool>
}

final class GameRepository: NSObject {
    typealias GameInstance = (LocalDataSource, RemoteDataSource) -> GameRepository
    fileprivate let local: LocalDataSource
    fileprivate let remote: RemoteDataSource

    private init(local: LocalDataSource, remote: RemoteDataSource) {
        self.local = local
        self.remote = remote
    }

    static let sharedInstance: GameInstance = { localRepo, remoteRepo in
        return GameRepository(local: localRepo, remote: remoteRepo)
    }

}
extension GameRepository: GameRepositoryProtocol {
    func findAll(query: String?, pageUrl: String?) -> Observable<[GameModel]> {
        return self.remote
            .findAll(query: query, pageUrl: pageUrl)
            .map { $0.results! }
            .map { GameMapper.mapResponsesToDomains(input: $0) }
    }

    func findOne(gameId: Int) -> Observable<GameModel> {
        return self.remote
            .findOne(gameId: gameId)
            .map { GameMapper.mapResponseToDomain(input: $0) }
    }

    func findAllSaved(query: String?) -> Observable<[GameModel]> {
        if let mQuery = query {
            return self.local
                .findAll()
                .map {
                    $0.filter { (item: GameEntity) -> Bool in
                        return item
                            .name
                            .range(of: mQuery, options: .caseInsensitive, range: nil, locale: nil) != nil
                    }
                }
                .map { GameMapper.mapEntitiesToDomains(input: $0) }
        } else {
            return self.local.findAll().map {
                GameMapper.mapEntitiesToDomains(input: $0)
            }
        }
    }

    func findOneSaved(gameId: Int) -> Observable<GameModel> {
        return self.local
            .findOne(gameId)
            .map { GameMapper.mapEntityToDomain(input: $0)}
    }

    func save(data: GameModel) -> Observable<Bool> {
        return self.local
            .save(data: GameMapper.mapDomainToEntity(input: data))
    }

    func delete(_ gameId: Int) -> Observable<Bool> {
        return self.local
            .delete(gameId)
    }
}
