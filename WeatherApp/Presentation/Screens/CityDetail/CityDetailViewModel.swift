import Foundation

final class CityDetailViewModel {

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    // MARK: - Dependencies

    private let weatherService: WeatherService
    private let weatherCache: WeatherCacheProtocol

    // MARK: - Data

    private(set) var city: City
    private(set) var weather: Weather?

    private(set) var state: State = .idle {
        didSet { onStateChanged?(state) }
    }

    // MARK: - Callbacks

    var onStateChanged: ((State) -> Void)?
    var onWeatherChanged: ((Weather?) -> Void)?

    // MARK: - Init

    init(
        city: City,
        weatherService: WeatherService = WeatherService(httpClient: HTTPClient()),
        weatherCache: WeatherCacheProtocol = WeatherCache()
    ) {
        self.city = city
        self.weatherService = weatherService
        self.weatherCache = weatherCache

        if let cached = weatherCache.get(cityId: city.id) {
            self.weather = cached
            self.state = .loaded
        }
    }

    // MARK: - Public API

    func load() {
        if let cached = weatherCache.get(cityId: city.id) {
            DispatchQueue.main.async {
                self.weather = cached
                self.onWeatherChanged?(cached)
                self.state = .loaded
            }
        } else {
            state = .loading
        }

        weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weatherCache.set(weather, for: self.city.id)
                    self.weather = weather
                    self.onWeatherChanged?(weather)
                    self.state = .loaded

                case .failure(let error):
                    if self.weather == nil {
                        self.onWeatherChanged?(nil)
                        self.state = .failed(error.localizedDescription)
                    }
                }
            }
        }
    }

    // MARK: - Presentation

    var titleText: String {
        "\(city.name), \(city.country)"
    }

    var temperatureText: String {
        guard let weather else { return "—" }
        return "\(Int(weather.temperature))°"
    }

    var conditionText: String {
        weather?.condition.capitalized ?? "—"
    }

    var feelsLikeText: String {
        guard let weather else { return "—" }
        return "Ощущается как \(Int(weather.feelsLike))°"
    }

    var windText: String {
        guard let weather else { return "—" }
        let speed = String(format: "%.1f", weather.windSpeed)
        return "Ветер: \(speed) м/с"
    }

    var updatedAtText: String {
        guard let weather else { return "—" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return "Обновлено: \(formatter.string(from: weather.updatedAt))"
    }
}
