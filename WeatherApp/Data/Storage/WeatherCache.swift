import Foundation

final class WeatherCache: WeatherCacheProtocol {
    private var storage: [UUID: Weather] = [:]

    func get(cityId: UUID) -> Weather? { storage[cityId] }

    func set(_ weather: Weather, for cityId: UUID) {
        storage[cityId] = weather
    }

    func clear() { storage.removeAll() }
}
