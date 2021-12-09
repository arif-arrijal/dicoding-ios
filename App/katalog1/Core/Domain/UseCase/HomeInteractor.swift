import Foundation
import RxSwift

protocol HomeUseCase {
    func findAll(query: String?, pageUrl: String?) -> Observable<[GameModel]>
}

class HomeInteractor: HomeUseCase {
    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func findAll(query: String?, pageUrl: String?) -> Observable<[GameModel]> {
        return repository.findAll(query: query, pageUrl: pageUrl)
    }
}
