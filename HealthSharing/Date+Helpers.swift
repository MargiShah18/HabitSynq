import Foundation

// Always use Sunday-first everywhere in your UI and logic!
let weekdaySymbols = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

extension Date {
    func toDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func weekdayShort() -> String {
        // Returns "Su" for Sunday, etc. (Sunday = 1 in .weekday)
        let idx = Calendar.current.component(.weekday, from: self) - 1 // 0=Su, 6=Sa
        return weekdaySymbols[idx]
    }

    /// Returns the 7 dates of the week for the current date, **starting from Sunday**.
    static func currentWeekDates() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 1 = Sunday
        let today = Date()
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today)!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: self),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: self))
        else { return [] }
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: firstDay) }
    }

    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: self)
    }

    func startOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}

// Helper to get the *Sunday* of the week for any date
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
}

extension Habit {
    // Returns true if this habit is active on the given date
    func isActive(on date: Date) -> Bool {
        if frequencyType == "Daily" {
            return true
        }
        let dayMap = ["Su":1, "Mo":2, "Tu":3, "We":4, "Th":5, "Fr":6, "Sa":7]
        let weekday = Calendar.current.component(.weekday, from: date) // 1=Su, ... 7=Sa
        let activeWeekdays = Set(frequencyDays.compactMap { dayMap[$0] })
        return activeWeekdays.contains(weekday)
    }
}
