import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<Weather, Error>) -> Void
    )
}
