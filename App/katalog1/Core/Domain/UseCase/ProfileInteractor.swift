import Foundation
import RxSwift

protocol ProfileUseCase {
    func getProfile() -> Observable<UserModel>
}

class ProfileInteractor: ProfileUseCase {
    private let repository: UserRepositoryProtocol

    required init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func getProfile() -> Observable<UserModel> {
        return self.repository.getProfile()
    }
}
