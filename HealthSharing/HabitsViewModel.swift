import Foundation
import FirebaseFirestore

enum CompletionStatus: String, Codable {
    case none
    case success
    case failure
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var completions: [String: [String: CompletionStatus]] = [:] // [habitId: [dateKey: status]]

    func fetchHabits(for userId: String) {
        let db = Firestore.firestore()
        db.collection("habits").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching habits: \(error)")
                return
            }
            guard let docs = snapshot?.documents else { return }
            let fetchedHabits = docs.compactMap { doc in
                let data = doc.data()
                return Habit(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    frequencyType: (data["frequency"] as? [String:Any])?["type"] as? String ?? "",
                    frequencyDays: (data["frequency"] as? [String:Any])?["days"] as? [String] ?? [],
                    frequencyCount: (data["frequency"] as? [String:Any])?["count"] as? Int
                )
            }
            DispatchQueue.main.async {
                self.habits = fetchedHabits
                for habit in self.habits {
                    self.fetchCompletions(for: habit)
                }
            }
        }
    }

    func fetchCompletions(for habit: Habit) {
        let db = Firestore.firestore()
        db.collection("habits")
            .document(habit.id)
            .collection("completion")
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                var results: [String: CompletionStatus] = [:]
                for doc in docs {
                    let data = doc.data()
                    if let done = data["done"] as? Bool,
                       let date = data["date"] as? String {
                        results[date] = done ? .success : .failure
                    }
                }
                DispatchQueue.main.async {
                    self.completions[habit.id] = results
                }
            }
    }

    func setCompletion(habit: Habit, date: Date, status: CompletionStatus) {
        let dateKey = date.toDateKey()
        if completions[habit.id] == nil {
            completions[habit.id] = [:]
        }
        completions[habit.id]?[dateKey] = status

        let db = Firestore.firestore()
        db.collection("habits").document(habit.id).collection("completion").document(dateKey).setData([
            "done": status == .success ? true : status == .failure ? false : nil,
            "date": dateKey,
            "userId": habit.id
        ])
    }
}
