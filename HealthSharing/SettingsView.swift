//
//  SettingsView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-04.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    let userName: String = "Margi"
    let userEmail: String = "margi@example.com"
    
    var userInitial: String {
        String(userName.prefix(1)).uppercased()
    }
    
    var body: some View {
        VStack(spacing:0){
            ZStack{
                Color.blue
                    .ignoresSafeArea(edges: .top)
                Text("Settings")
                    .font(.title2).bold()
                    .foregroundColor(.white)
            }
            .frame(height: 80)
            
            VStack(spacing:4){
                ZStack{
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width:70, height:70)
                    Text(userInitial)
                        .font(.system(size:34, weight:.bold))
                        .foregroundColor(.blue)
                }
                Text(userName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top,16)
            .padding(.bottom,32)
            
            Form{
                Section{
                    NavigationLink(destination: Text("Change Name Page")) {
                                            Label("Name", systemImage: "person")
                    }
                    NavigationLink(destination: Text("Change Email Page")) {
                                            Label("Email", systemImage: "envelope")
                    }
                    NavigationLink(destination: Text("Reset Password Page")) {
                                            Label("Reset Password", systemImage: "lock")
                    }
                    HStack {
                        Label("Week Start", systemImage: "calendar")
                        Spacer()
                        Text("Monday")
                            .foregroundColor(.gray)
                    }
                    NavigationLink(destination: Text("QR Code Page")) {
                                            Label("QR Code", systemImage: "qrcode")
                    }
                }
                Section {
                    NavigationLink(destination: Text("Review Support")) {
                        Label("Review Support", systemImage: "star")
                    }
                    NavigationLink(destination: Text("FAQs")) {
                        Label("FAQs", systemImage: "questionmark.circle")
                    }
                    NavigationLink(destination: Text("Feedback")) {
                        Label("Feedback", systemImage: "bubble.left.and.bubble.right")
                    }
                    NavigationLink(destination: Text("Notification Settings")) {
                        Label("Notification Settings", systemImage: "bell")
                    }
                }
               Section {
                   Button(action: {
                                        // Sign Out Logic Here
                    }) {
                    Label("Sign Out", systemImage: "arrowshape.turn.up.left")
                        .foregroundColor(.red)
                    }
                }
                Section {
                    Button(action: {
                                        // Delete Account Logic Here
                    }) {
                    Label("Delete Account", systemImage: "trash")
                        .foregroundColor(.red)
                    }
                }
            }
            .padding(.bottom,4)
            Spacer(minLength: 0)
            
            
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarHidden(true)
        
    }
}
#Preview {
    SettingsView()
}
