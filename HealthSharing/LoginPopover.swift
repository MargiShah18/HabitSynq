//
//  LoginPopover.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-27.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoginPopover: View {
    @Binding var isPresented: Bool
    @Binding var username: String
    @Binding var password: String
    var  didLogIn: () -> Void
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing:20){
            Text("Log In")
                .font(.title2).bold()
                .foregroundColor(.white)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            HStack(spacing:100){
                Button("Cancel"){
                    withAnimation{
                        isPresented = false
                    }
                }.foregroundColor(.red)
                
                
                Button("Submit"){
                    Auth.auth().signIn(withEmail: username, password: password){ result, error in
                        if let error = error {
                            print("Firebase login error: \(error)")
                            errorMessage = error.localizedDescription
                        }
                        else{
                            withAnimation {
                                isPresented = false
                                username = ""
                                password = ""
                                errorMessage = nil
                                didLogIn()
                            }
                        }
                        
                    }
                }
                    .foregroundColor(.blue)
                }
                .onDisappear{
                    username = ""
                    password = ""
                    errorMessage = nil
                }
                .padding(.horizontal)
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(radius: 12)
            .frame(maxWidth: 350)
            .transition(.scale)
        }
    }
    


