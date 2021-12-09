import Foundation
import RxSwift

class FavoritesPresenter {
    private let disposeBag = DisposeBag()
    private let useCase: FavoritesUseCase

    let data = PublishSubject<[GameModel]>()
    let loadingState = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()

    init(useCase: FavoritesUseCase) {
        self.useCase = useCase
    }

    func findAll(query: String? = nil) {
        loadingState.onNext(true)

        useCase.findAllSaved(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.data.onNext(result)
            } onError: { error in
                self.errorMessage.onNext(error.localizedDescription)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }
}
