import Foundation

// MARK: - WeatherViewModel
final class WeatherViewModel {

    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    // MARK: - Dependencies
    private let weatherService: WeatherService

    // MARK: - Output
    private(set) var state: State = .idle {
        didSet { notifyStateChanged() }
    }

    private(set) var weather: Weather? {
        didSet { notifyWeatherChanged() }
    }

    var onStateChanged: ((State) -> Void)?
    var onWeatherChanged: ((Weather?) -> Void)?

    // MARK: - Init
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    // MARK: - Public API
    func loadWeather(for city: City) {
        state = .loading

        weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weather):
                self.weather = weather
                self.state = .loaded

            case .failure(let error):
                self.weather = nil
                self.state = .failed(Self.localizedErrorMessage(for: error))
            }
        }
    }

    // MARK: - Presentation
    var temperatureText: String {
        guard let weather else { return L10n.placeholderDash }
        return L10n.temperatureValueFormat(Int(weather.temperature))
    }

    var feelsLikeText: String {
        guard let weather else { return L10n.placeholderDash }
        return L10n.feelsLikeValue(Int(weather.feelsLike))
    }

    var conditionText: String {
        weather?.condition.capitalized ?? L10n.placeholderDash
    }

    var windText: String {
        guard let weather else { return L10n.placeholderDash }
        return L10n.windValue(weather.windSpeed)
    }

    var updatedAtText: String {
        guard let weather else { return L10n.placeholderDash }
        let time = DateFormatter.localizedString(from: weather.updatedAt, dateStyle: .none, timeStyle: .short)
        return L10n.updatedAtValue(time)
    }

    // MARK: - Private
    private func notifyStateChanged() {
        if Thread.isMainThread {
            onStateChanged?(state)
        } else {
            DispatchQueue.main.async { [state] in
                self.onStateChanged?(state)
            }
        }
    }

    private func notifyWeatherChanged() {
        if Thread.isMainThread {
            onWeatherChanged?(weather)
        } else {
            DispatchQueue.main.async { [weather] in
                self.onWeatherChanged?(weather)
            }
        }
    }

    private static func localizedErrorMessage(for error: Error) -> String {
        if error is URLError {
            return L10n.errorNetwork
        }
        return L10n.errorUnknown
    }
}
