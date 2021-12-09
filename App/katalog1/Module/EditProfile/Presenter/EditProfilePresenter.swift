import Foundation
import RxSwift

class EditProfilePresenter {
    private let disposeBag = DisposeBag()
    private let useCase: EditProfileUseCase

    let data = PublishSubject<UserModel>()
    let saveProfileState = PublishSubject<Bool>()
    let loadingState = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()

    init(useCase: EditProfileUseCase) {
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

    func saveProfile(_ name: String, _ email: String, _ phone: String) {
        loadingState.onNext(true)

        let user = UserModel(name: name, email: email, phone: phone)
        useCase.saveProfile(data: user)
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.saveProfileState.onNext(true)
            } onError: { error in
                self.errorMessage.onNext(error.localizedDescription)
            } onCompleted: {
                self.loadingState.onNext(false)
            }.disposed(by: disposeBag)
    }
}
