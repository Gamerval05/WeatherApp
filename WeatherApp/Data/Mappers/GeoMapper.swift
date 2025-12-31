import Foundation

enum GeoMapper {

    static func map(_ dto: GeoDTO) -> City {
        City(
            name: dto.name,
            country: dto.country,
            latitude: dto.lat,
            longitude: dto.lon
        )
    }

    static func map(_ dtoList: [GeoDTO]) -> [City] {
        dtoList.map { map($0) }
    }
}
