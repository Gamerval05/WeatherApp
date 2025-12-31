import Foundation

enum WeatherMapper {
    static func map(_ dto: WeatherDTO) -> Weather {
        Weather(
            temperature: dto.main.temp,
            feelsLike: dto.main.feelsLike,
            condition: dto.weather.first?.description ?? "—",
            windSpeed: dto.wind.speed,
            updatedAt: Date(timeIntervalSince1970: dto.dt)
        )
    }
}
