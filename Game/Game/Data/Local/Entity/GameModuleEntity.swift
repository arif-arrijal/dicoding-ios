public struct GameModuleEntity {
    let gameId: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let ratingsCount: Int
    let reviewsTextCount: Int
    let slug: String? = nil
    let tba: Bool? = nil
    let ratings: [RatingModuleEntity]?
    let added: Int? = nil
    let description: String?
    let genres: [GenreModuleEntity]?
    let platforms: [PlatformModuleEntity]?
    let developers: [DeveloperModuleEntity]?
    let publishers: [PublisherModuleEntity]?
    let tags: [TagModuleEntity]?
    let website: String?
}

struct RatingModuleEntity: Codable {
    let ratingId: Int
    let title: String
    let count: Int
    let percent: Double
}

struct GenreModuleEntity: Codable {
    let name: String
}

struct PlatformModuleEntity: Codable {
    let platform: PlatformDetailModuleEntity
    let releasedAt: String?
}

struct PlatformDetailModuleEntity: Codable {
    let name: String
}

struct DeveloperModuleEntity: Codable {
    let name: String
}

struct PublisherModuleEntity: Codable {
    let name: String
}

struct TagModuleEntity: Codable {
    let name: String
}
