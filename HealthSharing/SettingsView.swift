//
//  SettingsView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-04.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var showNamePopover = false
    @State private var showEmailPopover = false
    @State private var showPasswordPopover = false
    
    @State private var newName: String = ""
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var userEmail: String = ""
    @State private var userDisplayName: String = ""
    
    var userName: String{
        if !userDisplayName.isEmpty{
            return userDisplayName
        }
        else if let atIndex = userEmail.firstIndex(of: "@"){
            return String((userEmail[..<atIndex]))
        }
        return ""
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
                    Text(userName.isEmpty ? "?" : String(userName.prefix(1)).uppercased())
                        .font(.system(size:34, weight:.bold))
                        .foregroundColor(.blue)
                    
                }
                Text(userName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(userEmail)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.top,16)
            .padding(.bottom,32)
            
            Form{
                Section{
                    //Name
                    Button{
                        newName = userName
                        showNamePopover = true
                    } label: {
                        HStack{
                            Label("Name", systemImage: "person")
                            Spacer()
                            Text(userName)
                                .foregroundColor(.gray)
                        }
                    }
                    .popover(isPresented: $showNamePopover) {
                        VStack(spacing: 16){
                            Text("Edit Name").font(.headline)
                            TextField("Name", text: $newName).textFieldStyle(.roundedBorder)
                            Button("Save"){
                                updateName()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .frame(width: 280)
                    }
                    //Email
                    Button{
                        newEmail = userEmail
                        showEmailPopover = true
                    } label: {
                        HStack{
                            Label("Email", systemImage: "envelope")
                            Spacer()
                            Text(userEmail)
                                .foregroundColor(.gray)
                        }
                    }
                    .popover(isPresented: $showEmailPopover) {
                        VStack(spacing: 16){
                            Text("Edit Email").font(.headline)
                            TextField("Email", text: $newEmail).textFieldStyle(.roundedBorder)
                            Button("Save"){
                                updateEmail()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .frame(width: 280)
                    }
                    //Password
                    Button{
                        showPasswordPopover = true
                    } label: {
                        Label("Reset Password", systemImage: "lock")
                    }
                    .popover(isPresented: $showPasswordPopover) {
                        VStack(spacing: 16){
                            Text("Reset Password").font(.headline)
                            TextField("New Password", text: $newPassword).textFieldStyle(.roundedBorder)
                            Button("Save"){
                                updatePassword()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .frame(width: 280)
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
        .onAppear{
            loadUserInfo()
        }
        
    }
    private func loadUserInfo() {
        if let user = Auth.auth().currentUser{
            userEmail = user.email ?? ""
            userDisplayName = user.displayName ?? ""
        }
    }
    private func updateName() {
        guard let user = Auth.auth().currentUser else {return}
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        changeRequest.commitChanges { error in
            if error == nil{
                userDisplayName = newName
                showNamePopover = false
            }
        }
    }
    private func updateEmail() {
        guard let user = Auth.auth().currentUser else {return}
        user.updateEmail(to: newEmail){error in
                if error == nil{
                userEmail = newEmail
                showEmailPopover = false
            }
        }
    }
    private func updatePassword() {
        guard let user = Auth.auth().currentUser else {return}
        user.updatePassword(to: newPassword){error in
                if error == nil{
                showPasswordPopover = false
            }
        }
    }

}
#Preview {
    SettingsView()
}
