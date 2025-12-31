import Foundation

final class CityListViewModel {

    // MARK: - State

    private let storage: CityStorageProtocol
    private(set) var cities: [City] = []

    // MARK: - Callbacks

    var onUpdate: (() -> Void)?

    // MARK: - Init

    init(storage: CityStorageProtocol = CityStorage()) {
        self.storage = storage
        loadCities()
    }

    // MARK: - Public API

    func loadCities() {
        cities = storage.load()
        onUpdate?()
    }

    func addCity(_ city: City) {
        guard !cities.contains(where: { $0.id == city.id }) else { return }
        cities.append(city)
        save()
    }

    func removeCity(at index: Int) {
        guard cities.indices.contains(index) else { return }
        cities.remove(at: index)
        save()
    }

    func city(at index: Int) -> City {
        cities[index]
    }

    func numberOfCities() -> Int {
        cities.count
    }

    // MARK: - Private

    private func save() {
        storage.save(cities)
        onUpdate?()
    }
}
