import Foundation
public struct GameDomainModel {
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
    let ratings: [RatingDomainModel]?
    let added: Int? = nil
    let description: String?
    let genres: [GenreDomainModel]?
    let platforms: [PlatformDomainModel]?
    let developers: [DeveloperDomainModel]?
    let publishers: [PublisherDomainModel]?
    let tags: [TagDomainModel]?
    let website: String?
}

struct RatingDomainModel {
    let ratingId: Int
    let title: String
    let count: Int
    let percent: Double
}

struct GenreDomainModel {
    let name: String
}

struct PlatformDomainModel {
    let platform: PlatformDetailDomainModel
    let releasedAt: String?
}

struct PlatformDetailDomainModel {
    let name: String
}

struct DeveloperDomainModel {
    let name: String
}

struct PublisherDomainModel {
    let name: String
}

struct TagDomainModel {
    let name: String
}
