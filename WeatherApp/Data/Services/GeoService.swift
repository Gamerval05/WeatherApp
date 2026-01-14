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
        let lang = (Bundle.main.preferredLocalizations.first ?? "en")
            .split(separator: "-")
            .first
            .map(String.init) ?? "en"
        guard let url = Endpoints.geoSearch(city: query, lang: lang) else {
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

    func reverseCityName(lat: Double, lon: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let lang = (Bundle.main.preferredLocalizations.first ?? "en")
            .split(separator: "-")
            .first
            .map(String.init) ?? "en"
        guard let url = Endpoints.geoReverse(lat: lat, lon: lon, lang: lang) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let dtos = try JSONDecoder().decode([GeoDTO].self, from: data)
                    if let first = dtos.first {
                        completion(.success(first.name))
                    } else {
                        completion(.failure(NetworkError.invalidResponse))
                    }
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
