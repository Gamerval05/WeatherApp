import Foundation

// MARK: - API Endpoints
enum Endpoints {

    // MARK: - Geo
    static func geoSearch(city: String, lang: String) -> URL? {
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = "/geo/1.0/direct"
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "appid", value: APIConfig.apiKey)
        ]
        return components?.url
    }

    static func geoReverse(lat: Double, lon: Double, lang: String) -> URL? {
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = "/geo/1.0/reverse"
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "appid", value: APIConfig.apiKey)
        ]
        return components?.url
    }

    // MARK: - Weather
    static func currentWeather(lat: Double, lon: Double, lang: String) -> URL? {
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = "/data/2.5/weather"
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "units", value: APIConfig.units),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "appid", value: APIConfig.apiKey)
        ]
        return components?.url
    }
}
