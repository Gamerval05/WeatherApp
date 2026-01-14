

import Foundation
import Alamofire

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case unknown
}

// MARK: - Error Mapping
extension NetworkError {
    static func map(_ error: Error) -> NetworkError {
        // Alamofire errors
        if let afError = error.asAFError {
            if afError.isSessionTaskError {
                return .invalidResponse
            }

            if let statusCode = afError.responseCode {
                return .serverError(statusCode: statusCode)
            }

            return .unknown
        }

        // Decoding errors
        if error is DecodingError {
            return .decodingError
        }

        return .unknown
    }
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L10n.errorInvalidURL
        case .invalidResponse:
            return L10n.errorInvalidResponse
        case .serverError:
            return L10n.errorServer
        case .decodingError:
            return L10n.errorDecoding
        case .unknown:
            return L10n.errorUnknown
        }
    }
}
