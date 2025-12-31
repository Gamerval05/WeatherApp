import UIKit

// MARK: - CityListViewController
final class CityListViewController: UITableViewController {

    // MARK: - Data
    private let cityStorage = CityStorage()
    private var cities: [City] = []

    // MARK: - Cache
    private let weatherCache: WeatherCacheProtocol = WeatherCache()

    // MARK: - Services
    private let weatherService = WeatherService(httpClient: HTTPClient())

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        cities = cityStorage.load()
        if cities.isEmpty {
            cities = [
                City(name: "Москва", country: "RU", latitude: 55.7558, longitude: 37.6173),
                City(name: "Санкт-Петербург", country: "RU", latitude: 59.9311, longitude: 30.3609),
                City(name: "Сочи", country: "RU", latitude: 43.5855, longitude: 39.7231)
            ]
            cityStorage.save(cities)
        }
        loadWeatherForAllCities()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Погода"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
    }

    private func setupTable() {
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseId)
        tableView.rowHeight = 56
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    @objc private func addTapped() {
        let geoService = GeoService(httpClient: HTTPClient())
        let searchVM = SearchCityViewModel(geoService: geoService)
        let searchVC = SearchCityViewController(viewModel: searchVM)

        searchVC.onCitySelected = { [weak self] city in
            self?.addCityIfNeeded(city)
        }

        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true)
    }

    @objc private func refreshPulled() {
        loadWeatherForAllCities(forceReload: true)
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseId, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }

        let city = cities[indexPath.row]
        let weather = weatherCache.get(cityId: city.id)
        cell.configure(city: city, weather: weather)
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city = cities[indexPath.row]
        let detailVM = CityDetailViewModel(city: city, weatherService: weatherService, weatherCache: weatherCache)
        let detailVC = CityDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Delete
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let city = cities[indexPath.row]
        cities.remove(at: indexPath.row)
        cityStorage.save(cities)

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Private
    private func addCityIfNeeded(_ city: City) {
        if cities.contains(where: { $0.name.lowercased() == city.name.lowercased() && $0.country == city.country }) {
            return
        }

        cities.insert(city, at: 0)
        cityStorage.save(cities)
        tableView.reloadData()
        loadWeather(for: city)
    }

    private func loadWeatherForAllCities(forceReload: Bool = false) {
        let group = DispatchGroup()

        for city in cities {
            if !forceReload, weatherCache.get(cityId: city.id) != nil {
                continue
            }

            group.enter()
            weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude) { [weak self] result in
                defer { group.leave() }
                guard let self = self else { return }

                if case .success(let weather) = result {
                    DispatchQueue.main.async {
                        self.weatherCache.set(weather, for: city.id)
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    private func loadWeather(for city: City) {
        weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude) { [weak self] result in
            guard let self = self else { return }

            if case .success(let weather) = result {
                DispatchQueue.main.async {
                    self.weatherCache.set(weather, for: city.id)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
