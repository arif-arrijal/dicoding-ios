public struct GameResponse: Codable {
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
    let ratings: [RatingResponse]?
    let added: Int? = nil
    let description: String?
    let genres: [GenreResponse]?
    let platforms: [PlatformResponse]?
    let developers: [DeveloperResponse]?
    let publishers: [PublisherResponse]?
    let tags: [TagResponse]?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case gameId = "id"
        case slug
        case name
        case released
        case tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case description
        case genres
        case platforms = "parent_platforms"
        case developers
        case publishers
        case tags
        case website
    }
}

struct RatingResponse: Codable {
    let ratingId: Int
    let title: String
    let count: Int
    let percent: Double

    enum CodingKeys: String, CodingKey {
        case ratingId = "id"
        case title
        case count
        case percent
    }
}

struct GenreResponse: Codable {
    let name: String
}

struct PlatformResponse: Codable {
    let platform: PlatformDetailResponse
    let releasedAt: String?
    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}

struct PlatformDetailResponse: Codable {
    let name: String
}

struct DeveloperResponse: Codable {
    let name: String
}

struct PublisherResponse: Codable {
    let name: String
}

struct TagResponse: Codable {
    let name: String
}
