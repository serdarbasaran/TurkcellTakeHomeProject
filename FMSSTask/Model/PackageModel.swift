
import UIKit

class PackageModel: Codable {
    
    var name: String?
    var desc: String?
    var subscriptionType: String?
    var didUseBefore: Bool?
    var benefits: [String]?
    var price: Double?
    var tariff: [String: String]?
    var availableUntil: String?
    
    var isFavorited: Bool?
    
}
