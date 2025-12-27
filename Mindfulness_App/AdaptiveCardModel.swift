import Foundation
import UIKit

/// Simple model for an adaptive card provided via JSON.
struct AdaptiveCardModel: Decodable {
    let id: String?
    let title: String
    let description: String
    let imageSystemName: String?
    let type: String?

    // Helper to provide a UIImage from the system name when present.
    func image() -> UIImage? {
        guard let name = imageSystemName else { return nil }
        return UIImage(systemName: name)
    }
}
