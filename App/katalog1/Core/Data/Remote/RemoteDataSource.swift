import Foundation
import RxSwift
import Alamofire
import Core

protocol RemoteDataSourceProtocol: AnyObject {
    func findAll(query: String?, pageUrl: String?) -> Observable<ApiResponse>
    func findOne(gameId: Int) -> Observable<GameResponse>
}

final class RemoteDataSource: NSObject {
    typealias RemoteDataSourceInstance = (NetworkService) -> RemoteDataSource
    fileprivate let service: NetworkService

    private init(service: NetworkService) {
        self.service = service
    }

    static let sharedInstance: RemoteDataSourceInstance = {service in
        return RemoteDataSource(service: service)
    }
}

extension RemoteDataSource: RemoteDataSourceProtocol {

    func findAll(query: String?, pageUrl: String?) -> Observable<ApiResponse> {
        var params: Parameters = [:]
        let findUrl = pageUrl ?? "\(service.baseUrl)/games"

        if query != nil && !query!.isEmpty {
            params["search"] = query
        }

        return Observable<ApiResponse>.create { observer in
            self.service.get(url: findUrl, type: ApiResponse.self, parameter: params) { result in
                switch result {
                case .success(let value):
                    if value.results != nil {
                        observer.onNext(value)
                        observer.onCompleted()
                    } else {
                        observer.onError(CustomError.dataNotFound)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(CustomError.serverError)
                }
            }
            return Disposables.create()
        }
    }

    func findOne(gameId: Int) -> Observable<GameResponse> {
        let url = "\(service.baseUrl)/games/\(gameId)"

        return Observable<GameResponse>.create { observer in
            self.service.get(url: url, type: GameResponse.self) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(CustomError.serverError)
                }
            }
            return Disposables.create()
        }
    }
}
