import Foundation

struct Item: Codable {
    var status: String
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Codable {
    var title: String
}

