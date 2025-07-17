import SwiftUI

struct HabitCalendarSheet: View {
    let habit: Habit
    @State private var completion: [Date: Bool] = [:] // true = green, false = red
    @State private var selectedDate: Date?
    @State private var showAlert = false
    
    // Map habit.frequencyDays ["Mo", "Tu", ...] to weekday numbers 1=Sun, 2=Mon,...
    var activeWeekdays: Set<Int> {
        let dayMap = ["Su":1, "Mo":2, "Tu":3, "We":4, "Th":5, "Fr":6, "Sa":7]
        return Set(habit.frequencyDays.compactMap { dayMap[$0] })
    }

    var body: some View {
        VStack {
            Text(habit.title)
                .font(.headline)
                .padding(.top)
            
            CalendarView(selectedDate: $selectedDate, completion: $completion, activeWeekdays: activeWeekdays)
                .frame(maxHeight: 400)
                .padding()
        }
        .onChange(of: selectedDate) { date in
            if let date = date, isDateSelectable(date) {
                showAlert = true
            }
        }
        .alert("Done for today?", isPresented: $showAlert) {
            Button("Yes", role: .none) { mark(date: selectedDate, done: true) }
            Button("No", role: .destructive) { mark(date: selectedDate, done: false) }
            Button("Cancel", role: .cancel) { selectedDate = nil }
        }
    }
    
    func isDateSelectable(_ date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        return activeWeekdays.contains(weekday)
    }
    
    func mark(date: Date?, done: Bool) {
        guard let date = date else { return }
        completion[date.stripTime()] = done
        selectedDate = nil
    }
}

// MARK: - Simple CalendarView (iOS 17+)
struct CalendarView: View {
    @Binding var selectedDate: Date?
    @Binding var completion: [Date: Bool]
    let activeWeekdays: Set<Int>
    
    @State private var currentMonth: Date = Date().startOfMonth()
    
    var body: some View {
        let days = currentMonth.daysInMonth()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        VStack {
            HStack {
                Button(action: { currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)! }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentMonth.monthYearString)
                    .font(.headline)
                Spacer()
                Button(action: { currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)! }) {
                    Image(systemName: "chevron.right")
                }
            }.padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                    Text(day).bold().frame(maxWidth: .infinity)
                }
                
                ForEach(days, id: \.self) { day in
                    let weekday = Calendar.current.component(.weekday, from: day)
                    let isSelectable = activeWeekdays.contains(weekday)
                    let isSelected = selectedDate?.stripTime() == day.stripTime()
                    let status = completion[day.stripTime()]
                    
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.blue : .clear, lineWidth: 2)
                            .background(
                                Circle()
                                    .fill(
                                        status == true ? Color.green :
                                            status == false ? Color.red :
                                            isSelectable ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1)
                                    )
                            )
                            .frame(width: 38, height: 38)
                        Text("\(Calendar.current.component(.day, from: day))")
                            .foregroundColor(isSelectable ? .primary : .gray)
                    }
                    .onTapGesture {
                        if isSelectable {
                            selectedDate = day
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Helpers
extension Date {
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

