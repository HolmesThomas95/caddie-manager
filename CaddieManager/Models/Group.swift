import Foundation

struct Group: Identifiable, Codable {
    let id: UUID
    var date: Date
    var requiredCaddies: Int
    var caddies: [Caddie]

    var isFullyAssigned: Bool {
        caddies.count >= requiredCaddies
    }
}
