import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HabitCalendarSheet: View {
    let habit: Habit
    var onSaved: (() -> Void)?
    
    @State private var completion: [String: Bool] = [:] // true = green, false = red
    @State private var selectedDate: Date?
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var userId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    var body: some View {
        VStack {
            Text(habit.title)
                .font(.headline)
                .padding(.top)
            
            CalendarView(
                habit: habit,
                selectedDate: $selectedDate,
                completion: completion,
                mark: mark
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
            if let date = date, habit.isActive(on: date) {
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
            ]) { error in
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
                var results: [String: Bool] = [:]
                for doc in docs {
                    let data = doc.data()
                    if let done = data["done"] as? Bool,
                       let date = data["date"] as? String {
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
            onSaved?()
            dismiss()
        }
    }
}

// MARK: - CalendarView with Sunday-first week
struct CalendarView: View {
    let habit: Habit
    @Binding var selectedDate: Date?
    var completion: [String: Bool]
    var mark: (Date?, Bool) -> Void
    
    @State private var currentMonth: Date = Date().startOfMonth()
    
    var body: some View {
        let days = currentMonth.daysInMonth()
        let firstDayWeekday = Calendar.current.component(.weekday, from: days.first ?? currentMonth) - 1 // 0=Sunday, 6=Saturday
        let leadingEmptyDays = Array(repeating: Date.distantPast, count: firstDayWeekday) // Placeholder dates
        let allDays = leadingEmptyDays + days
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        VStack {
            HStack {
                Button(action: {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentMonth.monthYearString)
                    .font(.headline)
                Spacer()
                Button(action: {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }.padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                ForEach(weekdaySymbols, id: \.self) { day in
                    Text(day).bold().frame(maxWidth: .infinity)
                }
                
                ForEach(Array(allDays.enumerated()), id: \.offset) { index, day in
                    let isPlaceholder = day == Date.distantPast
                    let isSelectable = !isPlaceholder && habit.isActive(on: day)
                    let isSelected = !isPlaceholder && selectedDate?.stripTime() == day.stripTime()
                    let key = isPlaceholder ? "" : dateKey(day)
                    let status = isPlaceholder ? nil : completion[key]
                    
                    ZStack {
                        if isPlaceholder {
                            // Empty space for alignment
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 38, height: 38)
                        } else {
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
                    }
                    .onTapGesture {
                        if !isPlaceholder && isSelectable {
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
