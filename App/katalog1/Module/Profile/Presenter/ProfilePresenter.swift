import Foundation
import RxSwift

class ProfilePresenter {
    private let disposeBag = DisposeBag()
    private let useCase: ProfileUseCase

    let data = PublishSubject<UserModel>()
    let loadingState = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()

    init(useCase: ProfileUseCase) {
        self.useCase = useCase
    }

    func getProfile() {
        loadingState.onNext(true)

        useCase.getProfile()
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
