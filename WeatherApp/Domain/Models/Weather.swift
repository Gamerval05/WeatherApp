import Foundation

struct Weather: Equatable {
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let windSpeed: Double
    let updatedAt: Date
}
