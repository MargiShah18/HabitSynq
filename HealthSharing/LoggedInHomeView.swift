//
//  LoggedInHomeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-28.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct Habit : Identifiable {
    var id :String
    var title : String
    var description : String
    var frequencyType : String
    var frequencyDays : [String]
    var frequencyCount : Int? // optional for week or month
}

struct LoggedInHomeView: View {
    @State private var showAddHabit = false
    @StateObject private var habitsVM = HabitsViewModel()
    @State private var showHabitSheet = false
    @State private var selectedHabit: Habit? = nil

    
    var userId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("My Habits")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack {
                    Spacer()
                    Button(action: {
                        showAddHabit = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .padding()
            .background(Color.blue)
            
            if habitsVM.habits.isEmpty {
                Spacer()
                Text("Add a habit and get started!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(habitsVM.habits) { habit in
                            HabitCardView(viewModel: habitsVM, habit: habit)
                                .onTapGesture{
                                    selectedHabit = habit
                                    showHabitSheet = true
                                }
                        }
                    }
                    .padding(.top, 16)
                }
                .background(Color(.systemGroupedBackground))
                .sheet(isPresented: $showHabitSheet){
                    if let habit = selectedHabit {
                        HabitCalendarSheet(habit: habit, onSaved: {
                            habitsVM.fetchHabits(for: userId)
                        })
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.container, edges: .bottom)
        .fullScreenCover(isPresented: $showAddHabit, onDismiss: {
            habitsVM.fetchHabits(for: userId)
        }) {
            NavigationStack {
                AddHabitView()
            }
        }
        .onAppear {
            habitsVM.fetchHabits(for: userId)
        }
    }
}

#Preview{
    LoggedInHomeView()
}
