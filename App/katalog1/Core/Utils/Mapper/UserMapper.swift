import Foundation

final class UserMapper {
    static func mapEntityToDomain(input response: UserEntity) -> UserModel {
        return UserModel(
            name: response.name, email: response.email, phone: response.phone
        )
    }
    static func mapDomainToEntity(input response: UserModel) -> UserEntity {
        return UserEntity(
            name: response.name, email: response.email, phone: response.phone
        )
    }
}
