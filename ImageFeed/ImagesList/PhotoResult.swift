import Foundation

struct PhotoResult: Decodable {

    let id: String
    let width: Double
    let height: Double
    let createdAt: String?
    let description: String?
    let isLiked: Bool
    let urls: UrlsResult

    struct UrlsResult: Decodable {
        let full: String
        let thumb: String
    }

    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
    }
}
