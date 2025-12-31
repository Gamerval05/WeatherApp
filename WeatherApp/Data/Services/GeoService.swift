import Foundation

// MARK: - GeoService
final class GeoService: GeoServiceProtocol {

    // MARK: - Dependencies
    private let httpClient: HTTPClient

    // MARK: - Init
    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
    }

    // MARK: - Public API
    func searchCity(query: String, completion: @escaping (Result<[City], Error>) -> Void) {
        guard let url = Endpoints.geoSearch(city: query) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let dtos = try JSONDecoder().decode([GeoDTO].self, from: data)
                    let cities = dtos.map {
                        City(
                            name: $0.name,
                            country: $0.country,
                            latitude: $0.lat,
                            longitude: $0.lon
                        )
                    }
                    completion(.success(cities))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
