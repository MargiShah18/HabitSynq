import FirebaseFirestore

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    func fetchHabits(for userId: String) {
        let db = Firestore.firestore()
        db.collection("habits").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching habits: \(error)")
                return
            }
            guard let docs = snapshot?.documents else { return }
            self.habits = docs.compactMap { doc in
                let data = doc.data()
                // Make sure you parse the fields correctly!
                return Habit(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    frequencyType: (data["frequency"] as? [String:Any])?["type"] as? String ?? "",
                    frequencyDays: (data["frequency"] as? [String:Any])?["days"] as? [String] ?? [],
                    frequencyCount: (data["frequency"] as? [String:Any])?["count"] as? Int
                )
            }
        }
    }
}
