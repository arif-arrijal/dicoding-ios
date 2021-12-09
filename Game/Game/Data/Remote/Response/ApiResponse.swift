import Foundation

public struct ApiResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [GameResponse]?
    let result: GameResponse?
}
