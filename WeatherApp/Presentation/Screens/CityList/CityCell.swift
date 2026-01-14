import UIKit

// MARK: - CityCell
final class CityCell: UITableViewCell {
    static let reuseId = "CityCell"

    // MARK: - UI
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()

    private let textStack = UIStackView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .default
        accessoryType = .disclosureIndicator

        iconLabel.font = .systemFont(ofSize: 28)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        tempLabel.font = .systemFont(ofSize: 18, weight: .bold)
        tempLabel.textAlignment = .right
        tempLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false

        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.distribution = .fill
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(iconLabel)
        contentView.addSubview(textStack)
        contentView.addSubview(tempLabel)

        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 34),

            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textStack.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: tempLabel.leadingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Configure
    func configure(city: City, weather: Weather?) {
        titleLabel.text = L10n.cityTitleFormat(city.name, city.country)

        if let weather {
            tempLabel.text = L10n.temperatureValueFormat(Int(weather.temperature))
            subtitleLabel.text = weather.condition
            iconLabel.text = WeatherIconMapper.icon(for: weather.condition)
        } else {
            tempLabel.text = L10n.placeholderDash
            subtitleLabel.text = L10n.loading
            iconLabel.text = L10n.cityCellLoadingIcon
        }
    }
}

// MARK: - WeatherIconMapper
enum WeatherIconMapper {

    // MARK: - Public
    static func icon(for condition: String) -> String {
        let c = condition.lowercased()

        if c.contains("clear") || c.contains("sun") || c.contains("яс") {
            return "☀️"
        }
        if c.contains("cloud") || c.contains("облач") {
            return "☁️"
        }
        if c.contains("rain") || c.contains("дожд") {
            return "🌧️"
        }
        if c.contains("drizzle") || c.contains("морос") {
            return "🌦️"
        }
        if c.contains("thunder") || c.contains("гроза") {
            return "⛈️"
        }
        if c.contains("snow") || c.contains("снег") {
            return "❄️"
        }
        if c.contains("mist") || c.contains("fog") || c.contains("haze") || c.contains("туман") {
            return "🌫️"
        }

        return "🌤️"
    }
}
