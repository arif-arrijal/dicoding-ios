import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func getProfile() -> Observable<UserModel>
    func saveProfile(data: UserModel) -> Observable<Bool>
}

final class UserRepository: NSObject {
    typealias UserInstance = (LocalDataSource) -> UserRepository
    fileprivate let local: LocalDataSource

    private init(local: LocalDataSource) {
        self.local = local
    }

    static let sharedInstance: UserInstance = { localRepo in
        return UserRepository(local: localRepo)
    }
}

extension UserRepository: UserRepositoryProtocol {
    func getProfile() -> Observable<UserModel> {
        return local.getProfile()
            .map { UserMapper.mapEntityToDomain(input: $0) }
    }

    func saveProfile(data: UserModel) -> Observable<Bool> {
        return local.saveProfile(data: UserMapper.mapDomainToEntity(input: data))
    }
}
