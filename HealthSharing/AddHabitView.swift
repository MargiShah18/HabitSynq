//
//  LoggedInHomeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-28.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitTitle: String = ""
    @State private var description: String = ""
    @State private var frequency: String = "Daily"
    @State private var showShareWith = false
    @State private var showReminders = false
    @State private var selectedDays: Set<String> = []
    let allDays = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"]
    @State private var daysPerWeek: String = ""
    @State private var daysPerMonth: String = ""
    
    let frequencyOptions = ["Daily", "Specific Days", "Number of Days per Week", "Number of days per Month"]
    
    var body: some View {
        VStack(alignment: .leading, spacing:6){
            ZStack{
                Text("Add Habit")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack{
                    Spacer()
                    Button(action:{
                        saveHabit()
                    })
                    {
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
            
            }
            .padding()
            .background(Color.blue)
            
            Spacer()
            Form {
                Section(header: Text("Habit Title")) {
                    TextField("Enter Habit name", text: $habitTitle)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 50)
                }
                
                FrequencySectionView(
                    frequency: $frequency,
                    selectedDays: $selectedDays,
                    daysPerWeek: $daysPerWeek,
                    daysPerMonth: $daysPerMonth,
                    allDays: allDays,
                    frequencyOptions: frequencyOptions
                )
                Section {
                    NavigationLink(destination: ShareWithView()) {
                        HStack {
                            Text("Share With")
                            Spacer()
                        }
                    }
                }
                Section {
                    NavigationLink(destination: RemindersView()) {
                        HStack {
                            Text("Reminders")
                            Spacer()
                        }
                    }
                }
            }

            
            FooterBar()
            
        }
        .background(Color.blue.opacity(0.25))
        .ignoresSafeArea(.container, edges: .bottom)
        
    }
    private func saveHabit(){
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }
        let db = Firestore.firestore()
        var frequencyData: [String: Any] = ["type": frequency]
            
            if frequency == "Daily" {
                frequencyData["days"] = allDays
            } else if frequency == "Specific Days" {
                frequencyData["days"] = Array(selectedDays)
            } else if frequency == "Number of Days per Week" {
                frequencyData["count"] = Int(daysPerWeek) ?? 0
            } else if frequency == "Number of Days per Month" {
                frequencyData["count"] = Int(daysPerMonth) ?? 0
            }
        let newHabit: [String: Any] = [
            "title": habitTitle,
            "description": description,
            "frequency": frequencyData,
            "userId": user.uid,
            "createdAt": FieldValue.serverTimestamp()
            ]
        db.collection("habits").addDocument(data: newHabit) { err in
            if let err = err {
                print("Error saving habit: \(err.localizedDescription)")
            } else {
                print("Habit Saved!")
                habitTitle = ""
                description = ""
                frequency = "Daily"
                daysPerWeek = ""
                daysPerMonth = ""
                selectedDays = []
                dismiss()
            }
        }
    }
}

struct ShareWithView: View {
    var body: some View {
        Text("Share with Friends")
            .navigationTitle("Share With")
    }
}

struct RemindersView: View {
    var body: some View {
        Text("RemindersView")
            .navigationTitle("Reminders")
    }
}

#Preview{
    NavigationStack{
        AddHabitView()
    }
}
