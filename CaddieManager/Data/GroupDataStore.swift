import Foundation
import Combine

class GroupDataStore: ObservableObject {
    @Published var groups: [Group] = []
    @Published var caddies: [Caddie] = []

    init() {
        // Sample data for development
        caddies = [Caddie(id: UUID(), name: "Joe"),
                   Caddie(id: UUID(), name: "Sam"),
                   Caddie(id: UUID(), name: "Pat")]
        groups = [Group(id: UUID(), date: Date(), requiredCaddies: 2, caddies: [caddies[0]]),
                  Group(id: UUID(), date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, requiredCaddies: 1, caddies: []),
                  Group(id: UUID(), date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!, requiredCaddies: 1, caddies: [caddies[1]])]
    }

    func groupsNeedingCaddies() -> [Group] {
        groups.filter { !$0.isFullyAssigned }
    }

    func groupsFullyAssigned() -> [Group] {
        groups.filter { $0.isFullyAssigned }
    }

    func groups(for dateRange: DateRange) -> [Group] {
        let calendar = Calendar.current
        let now = Date()
        switch dateRange {
        case .today:
            return groups.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .tomorrow:
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
                return groups.filter { calendar.isDate($0.date, inSameDayAs: tomorrow) }
            }
            return []
        case .nextWeek:
            if let weekAhead = calendar.date(byAdding: .day, value: 7, to: now) {
                return groups.filter { $0.date > now && $0.date <= weekAhead }
            }
            return []
        case .upcoming:
            return groups.filter { $0.date >= now }
        }
    }
}

enum DateRange {
    case today
    case tomorrow
    case nextWeek
    case upcoming
}
