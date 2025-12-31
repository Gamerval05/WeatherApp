import Foundation

protocol CityStorageProtocol {
    func load() -> [City]
    func save(_ cities: [City])
}
