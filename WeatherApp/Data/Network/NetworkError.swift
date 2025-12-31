

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {

    // MARK: - URL / Request
    case invalidURL
    case invalidResponse

    // MARK: - Server
    case serverError(statusCode: Int)

    // MARK: - Decoding
    case decodingError

    // MARK: - Unknown
    case unknown
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {

    // MARK: - Error Description
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .serverError(let statusCode):
            return "Ошибка сервера: \(statusCode)"
        case .decodingError:
            return "Ошибка обработки данных"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
