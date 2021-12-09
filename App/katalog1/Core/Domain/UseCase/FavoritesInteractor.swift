import Foundation
import RxSwift

protocol FavoritesUseCase {
    func findAllSaved(query: String?) -> Observable<[GameModel]>
}

class FavoritesInteractor: FavoritesUseCase {
    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func findAllSaved(query: String?) -> Observable<[GameModel]> {
        return self.repository.findAllSaved(query: query)
    }
}
