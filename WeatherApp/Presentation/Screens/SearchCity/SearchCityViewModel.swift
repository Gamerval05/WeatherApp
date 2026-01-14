import Foundation

// MARK: - SearchCityViewModel
final class SearchCityViewModel {

    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    // MARK: - Dependencies
    private let geoService: GeoServiceProtocol

    // MARK: - Output
    private(set) var state: State = .idle {
        didSet { onStateChanged?(state) }
    }

    private(set) var results: [City] = [] {
        didSet { onResultsChanged?(results) }
    }

    var onStateChanged: ((State) -> Void)?
    var onResultsChanged: (([City]) -> Void)?

    // MARK: - Init
    init(geoService: GeoServiceProtocol) {
        self.geoService = geoService
    }

    // MARK: - Public API
    func search(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count >= 2 else {
            results = []
            state = .idle
            return
        }

        state = .loading

        geoService.searchCity(query: trimmed) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let cities):
                self.results = cities
                self.state = .loaded

            case .failure(let error):
                self.results = []
                self.state = .failed(Self.localizedErrorMessage(for: error))
            }
        }
    }

    // MARK: - Private
    private static func localizedErrorMessage(for error: Error) -> String {
        // Keep mapping simple and user-friendly.
        if error is URLError {
            return L10n.errorNetwork
        }
        return L10n.errorUnknown
    }
}
