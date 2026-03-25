import Foundation

struct Project: Codable, Sendable {
    var id: Int?
    var title: String
    var description: String
    var goal: Double
    var currentAmount: Double
}