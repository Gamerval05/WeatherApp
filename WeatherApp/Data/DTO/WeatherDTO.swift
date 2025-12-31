

import Foundation

// MARK: - WeatherDTO
struct WeatherDTO: Decodable {
    let dt: TimeInterval
    let main: MainDTO
    let weather: [WeatherConditionDTO]
    let wind: WindDTO
}

// MARK: - MainDTO
struct MainDTO: Decodable {
    let temp: Double
    let feelsLike: Double

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

// MARK: - WeatherConditionDTO
struct WeatherConditionDTO: Decodable {
    let description: String
}

// MARK: - WindDTO
struct WindDTO: Decodable {
    let speed: Double
}
