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
    let allDays = weekdaySymbols
    @State private var daysPerWeek: String = ""
    @State private var daysPerMonth: String = ""
    
    let frequencyOptions = ["Daily", "Specific Days", "Days per Week", "Days per Month"]
    
    var body: some View {
        ZStack(alignment:.bottom){
            VStack(alignment: .leading, spacing:6){
                ZStack{
                    Text("Add Habit")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    HStack{
                        Button(action: { dismiss() }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
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
                
                
                Form {
                    Section(header: Text("Habit Title")) {
                        TextField("Enter Habit name", text: $habitTitle)
                    }
                    Section(header: Text("Description")) {
                        TextEditor(text: $description)
                            .frame(height: 50)
                    }
                    
                    Section(header: Text("Frequency")) {
                        Picker("Frequency", selection: $frequency) {
                            ForEach(frequencyOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Or MenuPickerStyle for a dropdown
                        
                        if frequency == "Specific Days" {
                            // User picks which days; checkbox style, not chips
                            ForEach(allDays, id: \.self) { day in
                                Toggle(isOn: Binding(
                                    get: { selectedDays.contains(day) },
                                    set: { isSelected in
                                        if isSelected { selectedDays.insert(day) }
                                        else { selectedDays.remove(day) }
                                    }
                                )) {
                                    Text(day)
                                }
                            }
                        }
                        if frequency == "Days per Week" {
                            TextField("How many days per week?", text: $daysPerWeek)
                                .keyboardType(.numberPad)
                        }
                        if frequency == "Days per Month" {
                            TextField("How many days per month?", text: $daysPerMonth)
                                .keyboardType(.numberPad)
                        }
                    }
                    
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
                .background(Color.blue.opacity(0.25))
                
                
            }
        
            
        }
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
            frequencyData["days"] = weekdaySymbols
        } else if frequency == "Specific Days" {
            frequencyData["days"] = Array(selectedDays)
        } else if frequency == "Days per Week" {
            frequencyData["count"] = Int(daysPerWeek) ?? 0
        } else if frequency == "Days per Month" {
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
