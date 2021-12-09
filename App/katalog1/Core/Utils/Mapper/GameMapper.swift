import Foundation

final class GameMapper {
    static func mapResponsesToDomains(input response: [GameResponse]) -> [GameModel] {
        return response.map { result in
            let newData = GameModel(
                gameId: result.gameId,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                ratingsCount: result.ratingsCount,
                reviewsTextCount: result.reviewsTextCount,
                ratings: result.ratings?.map { data in
                    return RatingModel(
                        ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                    )
                },
                description: result.description,
                genres: result.genres?.map { data in
                    return GenreModel(name: data.name)
                },
                platforms: result.platforms?.map { data in
                    return PlatformModel(
                        platform: PlatformDetailModel(name: data.platform.name),
                        releasedAt: data.releasedAt)
                },
                developers: result.developers?.map { data in
                    return DeveloperModel(name: data.name)
                },
                publishers: result.publishers?.map { data in
                    return PublisherModel(name: data.name)
                },
                tags: result.tags?.map { data in
                    return TagModel(name: data.name)
                },
                website: result.website
            )

            return newData
        }
    }

    static func mapResponseToDomain(input response: GameResponse) -> GameModel {
        return GameModel(
            gameId: response.gameId,
            name: response.name,
            released: response.released,
            backgroundImage: response.backgroundImage,
            rating: response.rating,
            ratingTop: response.ratingTop,
            ratingsCount: response.ratingsCount,
            reviewsTextCount: response.reviewsTextCount,
            ratings: response.ratings?.map { data in
                return RatingModel(
                    ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                )
            },
            description: response.description,
            genres: response.genres?.map { data in
                return GenreModel(name: data.name)
            },
            platforms: response.platforms?.map { data in
                return PlatformModel(
                    platform: PlatformDetailModel(name: data.platform.name),
                    releasedAt: data.releasedAt)
            },
            developers: response.developers?.map { data in
                return DeveloperModel(name: data.name)
            },
            publishers: response.publishers?.map { data in
                return PublisherModel(name: data.name)
            },
            tags: response.tags?.map { data in
                return TagModel(name: data.name)
            },
            website: response.website
        )
    }

    static func mapEntitiesToDomains(input response: [GameEntity]) -> [GameModel] {
        return response.map { result in
            let newData = GameModel(
                gameId: result.gameId,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                ratingsCount: result.ratingsCount,
                reviewsTextCount: result.reviewsTextCount,
                ratings: result.ratings?.map { data in
                    return RatingModel(
                        ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                    )
                },
                description: result.description,
                genres: result.genres?.map { data in
                    return GenreModel(name: data.name)
                },
                platforms: result.platforms?.map { data in
                    return PlatformModel(
                        platform: PlatformDetailModel(name: data.platform.name),
                        releasedAt: data.releasedAt)
                },
                developers: result.developers?.map { data in
                    return DeveloperModel(name: data.name)
                },
                publishers: result.publishers?.map { data in
                    return PublisherModel(name: data.name)
                },
                tags: result.tags?.map { data in
                    return TagModel(name: data.name)
                },
                website: result.website
            )

            return newData
        }
    }

    static func mapEntityToDomain(input response: GameEntity) -> GameModel {
        return GameModel(
            gameId: response.gameId,
            name: response.name,
            released: response.released,
            backgroundImage: response.backgroundImage,
            rating: response.rating,
            ratingTop: response.ratingTop,
            ratingsCount: response.ratingsCount,
            reviewsTextCount: response.reviewsTextCount,
            ratings: response.ratings?.map { data in
                return RatingModel(
                    ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                )
            },
            description: response.description,
            genres: response.genres?.map { data in
                return GenreModel(name: data.name)
            },
            platforms: response.platforms?.map { data in
                return PlatformModel(
                    platform: PlatformDetailModel(name: data.platform.name),
                    releasedAt: data.releasedAt)
            },
            developers: response.developers?.map { data in
                return DeveloperModel(name: data.name)
            },
            publishers: response.publishers?.map { data in
                return PublisherModel(name: data.name)
            },
            tags: response.tags?.map { data in
                return TagModel(name: data.name)
            },
            website: response.website
        )
    }

    static func mapDomainToEntity(input response: GameModel) -> GameEntity {
        return GameEntity(
            gameId: response.gameId,
            name: response.name,
            released: response.released,
            backgroundImage: response.backgroundImage,
            rating: response.rating,
            ratingTop: response.ratingTop,
            ratingsCount: response.ratingsCount,
            reviewsTextCount: response.reviewsTextCount,
            ratings: response.ratings?.map { data in
                return RatingEntity(
                    ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                )
            },
            description: response.description,
            genres: response.genres?.map { data in
                return GenreEntity(name: data.name)
            },
            platforms: response.platforms?.map { data in
                return PlatformEntity(
                    platform: PlatformDetailEntity(name: data.platform.name),
                    releasedAt: data.releasedAt)
            },
            developers: response.developers?.map { data in
                return DeveloperEntity(name: data.name)
            },
            publishers: response.publishers?.map { data in
                return PublisherEntity(name: data.name)
            },
            tags: response.tags?.map { data in
                return TagEntity(name: data.name)
            },
            website: response.website
        )
    }
}
