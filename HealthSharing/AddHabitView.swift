//
//  LoggedInHomeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-28.
//

import Foundation
import SwiftUI

struct AddHabitView: View {
    @State private var habitTitle: String = ""
    @State private var description: String = ""
    @State private var frequency: String = "Daily"
    @State private var showShareWith = false
    @State private var showReminders = false
    
    let frequencyOptions = ["Daily", "Specific Days", "Weekly", "Monthly"]
    
    var body: some View {
        VStack(spacing:0){
            ZStack{
                Text("Add Habit")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack{
                    Spacer()
                    Button(action:{
                        //Add action here
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
                    NavigationLink(destination: ShareWithView(), isActive: $showShareWith){
                        HStack{
                            Text("Share With")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                //Reminders (Navigation)
                Section{
                    NavigationLink(destination: RemindersView(), isActive: $showReminders){
                        HStack{
                            Text("Reminders")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
            }
            
            FooterBar()
            
        }
        .background(Color.blue.opacity(0.25))
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct RemindersView: View {
    var body: some View {
        Text("RemindersView")
            .navigationTitle("Share With")
    }
}
struct ShareWithView: View {
    var body: some View {
        Text("Share with Friends")
            .navigationTitle("Reminders")
    }
}


#Preview{
    AddHabitView()
}
