import Core
import Combine

public struct GetGamesRepository<
    GetGamesLocalDataSource: LocalDataSource,
    GetGamesRemoteDataSource: DataSource,
    Transformer: Mapper>: Repository
where
GetGamesLocalDataSource.Response == GameModuleEntity,
GetGamesRemoteDataSource.Request == GetGameRequest,
GetGamesRemoteDataSource.Response == ApiResponse,
Transformer.Response == [GameResponse],
Transformer.Entity == [GameModuleEntity],
Transformer.Domain == [GameDomainModel] {

    public typealias Request = GetGameRequest

    public typealias Response = [GameDomainModel]

    private let _localDataSource: GetGamesLocalDataSource
    private let _remoteDataSource: GetGamesRemoteDataSource
    private let _mapper: Transformer

    public init(
        localDataSource: GetGamesLocalDataSource,
        remoteDataSource: GetGamesRemoteDataSource,
        mapper: Transformer) {

            _localDataSource = localDataSource
            _remoteDataSource = remoteDataSource
            _mapper = mapper
    }

    public func execute(request: GetGameRequest?) -> AnyPublisher<[GameDomainModel], Error> {
        return _remoteDataSource.execute(request: request)
            .map { $0.results! }
            .map { _mapper.transformResponseToEntity(response: $0)}
            .map { _mapper.transformEntityToDomain(entity: $0)}
            .eraseToAnyPublisher()
    }
}
