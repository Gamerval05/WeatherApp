import Foundation
import Alamofire

// MARK: - HTTPClientProtocol
protocol HTTPClientProtocol {
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - HTTPClient
final class HTTPClient: HTTPClientProtocol {

    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
