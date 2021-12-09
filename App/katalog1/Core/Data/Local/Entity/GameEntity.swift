struct GameEntity {
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
    let ratings: [RatingEntity]?
    let added: Int? = nil
    let description: String?
    let genres: [GenreEntity]?
    let platforms: [PlatformEntity]?
    let developers: [DeveloperEntity]?
    let publishers: [PublisherEntity]?
    let tags: [TagEntity]?
    let website: String?
}

struct RatingEntity: Codable {
    let ratingId: Int
    let title: String
    let count: Int
    let percent: Double
}

struct GenreEntity: Codable {
    let name: String
}

struct PlatformEntity: Codable {
    let platform: PlatformDetailEntity
    let releasedAt: String?
}

struct PlatformDetailEntity: Codable {
    let name: String
}

struct DeveloperEntity: Codable {
    let name: String
}

struct PublisherEntity: Codable {
    let name: String
}

struct TagEntity: Codable {
    let name: String
}
