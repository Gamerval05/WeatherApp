import UIKit

// MARK: - SearchCityViewController
final class SearchCityViewController: UITableViewController {

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
        title = "Поиск города"
        view.backgroundColor = .systemBackground

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите город"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
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
                    self.navigationItem.prompt = "Поиск…"

                case .loaded:
                    self.navigationItem.prompt = nil

                case .failed(let message):
                    self.navigationItem.prompt = nil
                    let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let city = results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(city.name), \(city.country)"
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
