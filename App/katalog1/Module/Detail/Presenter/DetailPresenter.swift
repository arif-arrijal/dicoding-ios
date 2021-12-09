import Foundation
import RxSwift

class DetailPresenter {
    private let disposeBag = DisposeBag()
    private let detailUseCase: DetailUseCase
    var toBeSavedGame: GameModel?

    let data = PublishSubject<GameModel>()
    let loadingState = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()
    let alreadyBookmarkState = PublishSubject<Bool>()
    let saveBookmarkState = PublishSubject<Bool>()
    let deleteBookmarkState = PublishSubject<Bool>()

    init(useCase: DetailUseCase) {
        self.detailUseCase = useCase
    }

    func findOne(gameId: Int) {
        loadingState.onNext(true)

        detailUseCase.findOne(gameId: gameId)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.toBeSavedGame = result
                self.data.onNext(result)
            } onError: { error in
                self.errorMessage.onNext(error.localizedDescription)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }

    func checkAlreadyBookmark(gameId: Int) {
        loadingState.onNext(true)

        detailUseCase.findOneSaved(gameId: gameId)
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.alreadyBookmarkState.onNext(true)
            } onError: { _ in
                self.alreadyBookmarkState.onNext(false)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }

    func saveBookmark(data: GameModel) {
        loadingState.onNext(true)

        detailUseCase.save(data: data)
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.saveBookmarkState.onNext(true)
            } onError: { _ in
                self.saveBookmarkState.onNext(false)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }

    func deleteBookmark(gameId: Int) {
        loadingState.onNext(true)

        detailUseCase.delete(gameId: gameId)
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.deleteBookmarkState.onNext(true)
            } onError: { _ in
                self.deleteBookmarkState.onNext(false)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }
}
