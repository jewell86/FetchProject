import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Equatable {
    let cuisine: String?
    let name: String
    let smallPhoto: String?
    let largePhoto: String?
    let sourceURL: String?
    let uuid: String?
    let youtubeURl: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case smallPhoto = "photo_url_small"
        case largePhoto = "photo_url_large"
        case sourceURL = "source_url"
        case uuid = "uuid"
        case youtubeURl = "youtube_url"
    }
}
