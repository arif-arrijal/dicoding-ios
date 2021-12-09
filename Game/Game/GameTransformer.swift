import Core

public struct GameTransformer: Mapper {
    public func transformResponseToEntity(response: [GameResponse]) -> [GameModuleEntity] {
        return response.map { result in
            return GameModuleEntity(
                gameId: result.gameId,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                ratingsCount: result.ratingsCount,
                reviewsTextCount: result.reviewsTextCount,
                ratings: result.ratings?.map { data in
                    return RatingModuleEntity(
                        ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                    )
                },
                description: result.description,
                genres: result.genres?.map { data in
                    return GenreModuleEntity(name: data.name)
                },
                platforms: result.platforms?.map { data in
                    return PlatformModuleEntity(
                        platform: PlatformDetailModuleEntity(name: data.platform.name),
                        releasedAt: data.releasedAt)
                },
                developers: result.developers?.map { data in
                    return DeveloperModuleEntity(name: data.name)
                },
                publishers: result.publishers?.map { data in
                    return PublisherModuleEntity(name: data.name)
                },
                tags: result.tags?.map { data in
                    return TagModuleEntity(name: data.name)
                },
                website: result.website
            )
        }
    }

    public func transformEntityToDomain(entity: [GameModuleEntity]) -> [GameDomainModel] {
        return entity.map { result in
            return GameDomainModel(
                gameId: result.gameId,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                ratingsCount: result.ratingsCount,
                reviewsTextCount: result.reviewsTextCount,
                ratings: result.ratings?.map { data in
                    return RatingDomainModel(
                        ratingId: data.ratingId, title: data.title, count: data.count, percent: data.percent
                    )
                },
                description: result.description,
                genres: result.genres?.map { data in
                    return GenreDomainModel(name: data.name)
                },
                platforms: result.platforms?.map { data in
                    return PlatformDomainModel(
                        platform: PlatformDetailDomainModel(name: data.platform.name),
                        releasedAt: data.releasedAt)
                },
                developers: result.developers?.map { data in
                    return DeveloperDomainModel(name: data.name)
                },
                publishers: result.publishers?.map { data in
                    return PublisherDomainModel(name: data.name)
                },
                tags: result.tags?.map { data in
                    return TagDomainModel(name: data.name)
                },
                website: result.website
            )
        }
    }

    public typealias Response = [GameResponse]

    public typealias Entity = [GameModuleEntity]

    public typealias Domain = [GameDomainModel]

    public init() {}

}
