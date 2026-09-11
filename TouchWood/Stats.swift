import Combine
import Foundation

/// Persisted lifetime knock count and consecutive-day streak.
/// Everything lives in UserDefaults on the device; nothing leaves the phone.
final class Stats: ObservableObject {
    static let shared = Stats()

    @Published private(set) var total: Int
    @Published private(set) var streak: Int

    private let defaults = UserDefaults.standard

    private enum Key {
        static let total = "touchTotal"
        static let streak = "touchStreak"
        static let lastDay = "touchLastDay"
    }

    private init() {
        total = defaults.integer(forKey: Key.total)
        streak = defaults.integer(forKey: Key.streak)
    }

    /// Records one knock and rolls the streak forward.
    /// Same day: streak unchanged. Next day: streak grows. Any longer gap: back to 1.
    func record(now: Date = Date()) {
        total += 1
        defaults.set(total, forKey: Key.total)

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)

        if let last = defaults.object(forKey: Key.lastDay) as? Date {
            let gap = calendar.dateComponents([.day], from: calendar.startOfDay(for: last), to: today).day ?? 0
            if gap != 0 {
                streak = gap == 1 ? streak + 1 : 1
            } else if streak == 0 {
                streak = 1
            }
        } else {
            streak = 1
        }

        defaults.set(today, forKey: Key.lastDay)
        defaults.set(streak, forKey: Key.streak)
    }

    func reset() {
        total = 0
        streak = 0
        defaults.removeObject(forKey: Key.total)
        defaults.removeObject(forKey: Key.streak)
        defaults.removeObject(forKey: Key.lastDay)
    }
}
