import Core
import Combine
import Foundation
import Alamofire

public struct GetGamesRemoteDataSource: DataSource {
    public typealias Request = GetGameRequest
    public typealias Response = ApiResponse

    fileprivate let _service: NetworkService

    private let _endpoint: String

    public init(endpoint: String, service: NetworkService) {
        _endpoint = endpoint
        _service = service
    }

    public func execute(request: GetGameRequest?) -> AnyPublisher<ApiResponse, Error> {
        var params: Parameters = [:]
        var findUrl = "\(_service.baseUrl)/games"

        if let _request = request {
            if _request.pageUrl != nil {
                findUrl = _request.pageUrl!
            }

            if _request.query != nil && !_request.query!.isEmpty {
                params["search"] = _request.query
            }
        }

        return Future<ApiResponse, Error> { completion in
            self._service.get(url: findUrl, type: ApiResponse.self, parameter: params) { result in
                switch result {
                case .success(let value):
                    if value.results != nil {
                        completion(.success(value))
                    } else {
                        completion(.failure(CustomError.dataNotFound))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
