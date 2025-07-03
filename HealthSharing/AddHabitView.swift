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
    @State private var habitTitle: String = ""
    @State private var description: String = ""
    @State private var frequency: String = "Daily"
    @State private var showShareWith = false
    @State private var showReminders = false
    
    let frequencyOptions = ["Daily", "Specific Days", "Weekly", "Monthly"]
    
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
                //Habit Title
                Section(header: Text("Habit Title")){
                    TextField("Enter Habit name", text:$habitTitle)
                }
                //Description
                Section(header: Text("Description")){
                    TextEditor(text:$description)
                        .frame(height: 50)
                }
                //Frequency (Dropdown)
                Section(header:Text("Frequency")){
                    Picker("Frequency", selection: $frequency){
                        ForEach(frequencyOptions,id: \.self){ option in Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                //Share with (Navigation)
                Section{
                    NavigationLink(destination: ShareWithView()){
                        HStack{
                            Text("Share With")
                            Spacer()
                        }
                    }
                }
                //Reminders (Navigation)
                Section{
                    NavigationLink(destination: RemindersView()){
                        HStack{
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
        let newHabit: [String: Any] = [
            "title": habitTitle,
            "description": description,
            "frequency": frequency,
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
