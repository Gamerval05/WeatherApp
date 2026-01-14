import UIKit
import RswiftResources

// MARK: - UITableViewCell

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

// MARK: - UIView

extension UIView {
    func pinToEdges(of superview: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

// MARK: - UIViewController.
//test
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
        present(alert, animated: true)
    }

    func showError(_ message: String) {
        showAlert(title: L10n.errorTitle, message: message)
    }
}

// MARK: - Date

extension Date {
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
}

// MARK: - Localization

enum L10n {
    static var weatherTitle: String { R.string.localizable.weather_title() }

    static var cityListTitle: String { R.string.localizable.city_list_title() }
    static var cityAdd: String { R.string.localizable.city_add() }
    static var cityDelete: String { R.string.localizable.city_delete() }
    static var cityEmpty: String { R.string.localizable.city_empty() }
    static var citySearchPlaceholder: String { R.string.localizable.city_search_placeholder() }
    static func cityTitleFormat(_ city: String, _ country: String) -> String {
        R.string.localizable.city_title_format(city, country)
    }

    static func temperatureValueFormat(_ value: Int) -> String {
        R.string.localizable.temperature_value_format(value)
    }

    static func feelsLikeValue(_ value: Int) -> String {
        R.string.localizable.feels_like_value(value)
    }

    static func windValue(_ speed: Double) -> String {
        R.string.localizable.wind_value(String(format: "%.1f", speed))
    }

    static func updatedAtValue(_ time: String) -> String {
        R.string.localizable.updated_at_value(time)
    }

    static var searchTitle: String { R.string.localizable.search_title() }
    static var searchPrompt: String { R.string.localizable.search_prompt() }
    static var searchLoadingPrompt: String { R.string.localizable.search_loading_prompt() }
    static var searchCancel: String { R.string.localizable.search_cancel() }
    static var searchEmpty: String { R.string.localizable.search_empty() }

    static var weatherDetails: String { R.string.localizable.weather_details() }
    static var forecast: String { R.string.localizable.forecast() }

    static var temperature: String { R.string.localizable.temperature() }
    static var feelsLike: String { R.string.localizable.feels_like() }
    static var humidity: String { R.string.localizable.humidity() }
    static var pressure: String { R.string.localizable.pressure() }
    static var wind: String { R.string.localizable.wind() }
    static var visibility: String { R.string.localizable.visibility() }

    static var pressureUnit: String { R.string.localizable.pressure_unit() }
    static var windUnit: String { R.string.localizable.wind_unit() }
    static var visibilityUnit: String { R.string.localizable.visibility_unit() }

    static var loading: String { R.string.localizable.loading() }
    static var retry: String { R.string.localizable.retry() }
    static var pullToRefresh: String { R.string.localizable.pull_to_refresh() }
    static var lastUpdate: String { R.string.localizable.last_update() }


    static var errorTitle: String { R.string.localizable.error_title() }
    static var errorNetwork: String { R.string.localizable.error_network() }
    static var errorUnknown: String { R.string.localizable.error_unknown() }

    // MARK: - Network Errors
    static var errorInvalidURL: String { R.string.localizable.error_invalid_url() }
    static var errorInvalidResponse: String { R.string.localizable.error_invalid_response() }
    static var errorServer: String { R.string.localizable.error_server() }
    static var errorDecoding: String { R.string.localizable.error_decoding() }

    static var ok: String { R.string.localizable.ok() }
    static var cancel: String { R.string.localizable.cancel() }
    static var add: String { R.string.localizable.add() }
    static var back: String { R.string.localizable.back() }
    static var refresh: String { R.string.localizable.refresh() }
    static var updatedAt: String { R.string.localizable.updated_at() }

    // MARK: - Common placeholders
    static var placeholderDash: String { R.string.localizable.placeholder_dash() }

    // MARK: - CityCell
    static var cityCellLoadingIcon: String { R.string.localizable.city_cell_loading_icon() }
}
