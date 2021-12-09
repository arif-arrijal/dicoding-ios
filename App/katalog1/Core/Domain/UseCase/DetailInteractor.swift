import Foundation
import RxSwift

protocol DetailUseCase {
    func findOne(gameId: Int) -> Observable<GameModel>
    func findOneSaved(gameId: Int) -> Observable<GameModel>
    func save(data: GameModel) -> Observable<Bool>
    func delete(gameId: Int) -> Observable<Bool>
}

class DetailInteractor: DetailUseCase {
    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func findOne(gameId: Int) -> Observable<GameModel> {
        return self.repository.findOne(gameId: gameId)
    }

    func findOneSaved(gameId: Int) -> Observable<GameModel> {
        return self.repository.findOneSaved(gameId: gameId)
    }

    func save(data: GameModel) -> Observable<Bool> {
        return self.repository.save(data: data)
    }

    func delete(gameId: Int) -> Observable<Bool> {
        return self.repository.delete(gameId)
    }
}
