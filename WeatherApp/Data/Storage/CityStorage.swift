import Foundation

// MARK: - CityStorage
final class CityStorage: CityStorageProtocol {

    // MARK: - Keys
    private enum Keys {
        static let cities = "weatherapp.cities"
    }

    // MARK: - Dependencies
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Init
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Load
    func loadCities() -> [City] {
        guard let data = defaults.data(forKey: Keys.cities) else {
            return []
        }

        do {
            return try decoder.decode([City].self, from: data)
        } catch {
            return []
        }
    }

    // MARK: - Compatibility
    func load() -> [City] {
        loadCities()
    }

    // MARK: - Save
    func saveCities(_ cities: [City]) {
        do {
            let data = try encoder.encode(cities)
            defaults.set(data, forKey: Keys.cities)
        } catch {
            // Intentionally ignore encoding errors for this demo
        }
    }

    func save(_ cities: [City]) {
        saveCities(cities)
    }

    // MARK: - Clear
    func clear() {
        defaults.removeObject(forKey: Keys.cities)
    }
}
