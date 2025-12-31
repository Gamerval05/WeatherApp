import Foundation

// MARK: - GeoServiceProtocol
protocol GeoServiceProtocol {
    func searchCity(query: String, completion: @escaping (Result<[City], Error>) -> Void)
}
