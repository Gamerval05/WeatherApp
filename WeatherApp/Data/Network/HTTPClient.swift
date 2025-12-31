import Foundation

// MARK: - HTTPClientProtocol
protocol HTTPClientProtocol {
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - HTTPClient
final class HTTPClient: HTTPClientProtocol {

    // MARK: - Properties
    private let session: URLSession

    // MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public methods
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                if let body = String(data: data, encoding: .utf8) {
                    print("[HTTPClient] HTTP ERROR \(httpResponse.statusCode): \(body)")
                } else {
                    print("[HTTPClient] HTTP ERROR \(httpResponse.statusCode): <no body>")
                }
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
