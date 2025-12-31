import UIKit

// MARK: - CityDetailViewController
final class CityDetailViewController: UIViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let refreshControl = UIRefreshControl()

    private let temperatureLabel = UILabel()
    private let iconLabel = UILabel()
    private let conditionLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let windLabel = UILabel()
    private let updatedAtLabel = UILabel()

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    // MARK: - Dependencies
    private let viewModel: CityDetailViewModel

    // MARK: - Init
    init(viewModel: CityDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.load()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.titleText

        configureLabels()
        configureErrorLabel()

        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let stack = UIStackView(arrangedSubviews: [
            temperatureLabel,
            iconLabel,
            conditionLabel,
            feelsLikeLabel,
            windLabel,
            updatedAtLabel
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Обновить",
            style: .plain,
            target: self,
            action: #selector(refreshTapped)
        )

        render()
    }

    private func configureLabels() {
        iconLabel.font = .systemFont(ofSize: 42)
        iconLabel.textAlignment = .center

        temperatureLabel.font = .systemFont(ofSize: 56, weight: .bold)
        temperatureLabel.textAlignment = .center

        conditionLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        conditionLabel.textAlignment = .center
        conditionLabel.numberOfLines = 0

        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.numberOfLines = 0

        windLabel.font = .systemFont(ofSize: 16)
        windLabel.textAlignment = .center
        windLabel.numberOfLines = 0

        updatedAtLabel.font = .systemFont(ofSize: 13)
        updatedAtLabel.textAlignment = .center
        updatedAtLabel.numberOfLines = 0
        updatedAtLabel.textColor = .secondaryLabel
    }

    private func configureErrorLabel() {
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
    }

    // MARK: - Binding
    private func bind() {
        viewModel.onStateChanged = { [weak self] _ in
            self?.render()
        }
        viewModel.onWeatherChanged = { [weak self] _ in
            self?.render()
        }
    }

    // MARK: - Actions
    @objc private func refreshPulled() {
        viewModel.load()
    }

    @objc private func refreshTapped() {
        viewModel.load()
    }

    // MARK: - Render
    private func render() {
        temperatureLabel.text = viewModel.temperatureText
        iconLabel.text = WeatherIconMapper.icon(for: viewModel.conditionText)
        conditionLabel.text = viewModel.conditionText
        feelsLikeLabel.text = viewModel.feelsLikeText
        windLabel.text = viewModel.windText
        updatedAtLabel.text = viewModel.updatedAtText

        switch viewModel.state {
        case .idle:
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true

        case .loading:
            activityIndicator.startAnimating()
            errorLabel.isHidden = true

        case .loaded:
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true

        case .failed(let message):
            activityIndicator.stopAnimating()
            errorLabel.text = message
            errorLabel.isHidden = false
        }
        if refreshControl.isRefreshing, viewModel.state != .loading {
            refreshControl.endRefreshing()
        }
    }
}
