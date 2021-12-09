import Foundation
import RxSwift

protocol EditProfileUseCase {
    func getProfile() -> Observable<UserModel>
    func saveProfile(data: UserModel) -> Observable<Bool>
}

class EditProfileInteractor: EditProfileUseCase {
    private let repository: UserRepositoryProtocol

    required init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func getProfile() -> Observable<UserModel> {
        return self.repository.getProfile()
    }

    func saveProfile(data: UserModel) -> Observable<Bool> {
        return self.repository.saveProfile(data: data)
    }
}
