import Foundation
struct GameModel {
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
    let ratings: [RatingModel]?
    let added: Int? = nil
    let description: String?
    let genres: [GenreModel]?
    let platforms: [PlatformModel]?
    let developers: [DeveloperModel]?
    let publishers: [PublisherModel]?
    let tags: [TagModel]?
    let website: String?
}

struct RatingModel {
    let ratingId: Int
    let title: String
    let count: Int
    let percent: Double
}

struct GenreModel {
    let name: String
}

struct PlatformModel {
    let platform: PlatformDetailModel
    let releasedAt: String?
}

struct PlatformDetailModel {
    let name: String
}

struct DeveloperModel {
    let name: String
}

struct PublisherModel {
    let name: String
}

struct TagModel {
    let name: String
}
