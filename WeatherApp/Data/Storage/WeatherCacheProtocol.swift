import Foundation

protocol WeatherCacheProtocol {
    func get(cityId: UUID) -> Weather?
    func set(_ weather: Weather, for cityId: UUID)
    func clear()
}
