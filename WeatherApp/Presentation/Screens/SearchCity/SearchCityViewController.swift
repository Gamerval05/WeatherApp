import UIKit

// MARK: - SearchCityViewController
final class SearchCityViewController: UITableViewController {
    private static let searchCellReuseId = "SearchCell"

    // MARK: - Dependencies
    private let viewModel: SearchCityViewModel

    // MARK: - UI
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Callbacks
    var onCitySelected: ((City) -> Void)?

    // MARK: - Data
    private var results: [City] = []

    // MARK: - Init
    init(viewModel: SearchCityViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
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
    }

    // MARK: - Setup
    private func setupUI() {
        title = L10n.searchTitle
        view.backgroundColor = .systemBackground

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.searchCellReuseId)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.searchPrompt

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.searchCancel,
            style: .done,
            target: self,
            action: #selector(closeTapped)
        )
    }

    // MARK: - Binding
    private func bind() {
        viewModel.onResultsChanged = { [weak self] cities in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.results = cities
                self.tableView.reloadData()
            }
        }

        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch state {
                case .idle:
                    break

                case .loading:
                    self.navigationItem.prompt = L10n.searchLoadingPrompt

                case .loaded:
                    self.navigationItem.prompt = nil

                case .failed(let message):
                    self.navigationItem.prompt = nil
                    let alert = UIAlertController(title: L10n.errorTitle, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.searchCellReuseId, for: indexPath)
        let city = results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = L10n.cityTitleFormat(city.name, city.country)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = results[indexPath.row]
        onCitySelected?(city)
        dismiss(animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.search(query: text)
    }
}
