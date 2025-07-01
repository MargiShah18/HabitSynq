//
//  LoggedInHomeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-28.
//

import Foundation
import SwiftUI

struct LoggedInHomeView: View {
    @State private var showAddHabit = false
    
    var body: some View {
        VStack(spacing:0){
            ZStack{
                Text("My Habits")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack{
                    Spacer()
                    Button(action:{
                        showAddHabit = true
                    })
                    {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .padding()
            .background(Color.blue)
            
            Spacer()
            Text("Add a habit and get started!")
            Spacer()
            FooterBar()
            
        }
        .background(Color.blue.opacity(0.25))
        .ignoresSafeArea(.container, edges: .bottom)
        .fullScreenCover(isPresented: $showAddHabit) {
            AddHabitView()
        }
    }
}
#Preview{
    LoggedInHomeView()
}
