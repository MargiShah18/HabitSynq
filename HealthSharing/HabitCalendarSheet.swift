import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HabitCalendarSheet: View {
    let habit: Habit
    
    var onSaved: (()->Void)?
    @State private var completion: [String: Bool] = [:] // true = green, false = red
    @State private var selectedDate: Date?
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var userId: String {
            Auth.auth().currentUser?.uid ?? ""
        }

    
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
            
            CalendarView(
                selectedDate: $selectedDate,
                completion: completion,
                activeWeekdays: activeWeekdays,
                mark:mark
            )
                .frame(maxHeight: 400)
                .padding()
            
            Spacer()
            
            Button(action: saveAll) {
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
        }
        .onAppear {
            fetchCompletion()
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
    
    func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func isDateSelectable(_ date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        return activeWeekdays.contains(weekday)
    }
    
    func mark(date: Date?, done: Bool) {
        guard let date = date else { return }
        let key = dateKey(date)
        completion[key] = done
        selectedDate = nil
        
        let db = Firestore.firestore()
        db.collection("habits")
            .document(habit.id)
            .collection("completion")
            .document(key)
            .setData([
                "done": done,
                "date": key,
                "userId": userId
            ]){ error in
                if let error = error {
                    print("Error saving completion: \(error)")
                }
            }
    }
    func fetchCompletion() {
        let db = Firestore.firestore()
        db.collection("habits")
            .document(habit.id)
            .collection("completion")
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                var results: [String:Bool] = [:]
                for doc in docs {
                    let data = doc.data()
                    if let done = data["done"] as? Bool,
                       let date = data["date"] as? String
                    {
                        results[date] = done
                    }
                }
                completion = results
            }
    }
    func saveAll() {
            let db = Firestore.firestore()
            let group = DispatchGroup()
            for (dateString, done) in completion {
                group.enter()
                db.collection("habits")
                    .document(habit.id)
                    .collection("completion")
                    .document(dateString)
                    .setData([
                        "done": done,
                        "date": dateString,
                        "userId": userId
                    ]) { _ in group.leave() }
            }
            group.notify(queue: .main) {
                // Call the parent refresh (optional)
                onSaved?()
                dismiss()
            }
        }
}

// MARK: - Simple CalendarView (iOS 17+)
struct CalendarView: View {
    @Binding var selectedDate: Date?
    var completion: [String: Bool]
    let activeWeekdays: Set<Int>
    var mark: (Date?, Bool)-> Void
    
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
                    let key = dateKey(day)
                    let status = completion[key]
                    
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
    func dateKey(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
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

