import Foundation
import Alamofire
import Core

protocol NetworkServiceProtocol {
    func get<T: Codable>(
        url: String,
        type: T.Type,
        parameter: Parameters?,
        completion: @escaping (Result<T, Error>) -> Void)
    var baseUrl: String { get }
}

public class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private init() {}

    func get<T: Codable>(
        url: String,
        type: T.Type,
        parameter: Parameters? = nil,
        completion: @escaping (Result<T, Error>) -> Void) {
        if let validURL = URL(string: url) {
            AF.request(validURL, parameters: getParams(parameter))
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success:
                        guard let value = response.value else { return }
                        completion(.success(value))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        }

    }

    func getParams(_ parameters: Parameters?) -> Parameters {
        var defaultParams = ["key": apiKey]
        if let params = parameters {
            params.forEach { param in
                defaultParams[param.key] = param.value as? String
            }
        }
        return defaultParams
    }

    private var dictionary: NSDictionary? {
        guard let filePath = Bundle.main.path(forResource: "Secret-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Secret-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        return plist
    }

    private var apiKey: String {
        guard let value = dictionary?.object(forKey: "API_KEY") as? String else {
            fatalError(CustomError.keyNotFound.localizedDescription)
        }
        return value
    }

    var baseUrl: String {
        guard let value = dictionary?.object(forKey: "BASE_URL") as? String else {
            fatalError(CustomError.keyNotFound.localizedDescription)
        }
        return value
    }
}
