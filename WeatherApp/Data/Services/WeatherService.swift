import Foundation

// MARK: - WeatherService
final class WeatherService: WeatherServiceProtocol {

    // MARK: - Dependencies
    private let httpClient: HTTPClient

    // MARK: - Init
    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
    }

    // MARK: - Public API
    func fetchCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<Weather, Error>) -> Void
    ) {
        let lang = Bundle.main.preferredLocalizations.first ?? "en"
        guard let url = Endpoints.currentWeather(lat: lat, lon: lon, lang: lang) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let dto = try JSONDecoder().decode(WeatherDTO.self, from: data)
                    let weather = WeatherMapper.map(dto)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
