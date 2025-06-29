//
//  LoginPopover.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-27.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SignupPopover: View {
    @Binding var isPresented: Bool
    @Binding var username: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing:20){
            Text("Sign up")
                .font(.title2).bold()
                .foregroundColor(.white)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("Confirm Password", text: $confirmPassword)
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
                    
                    if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        errorMessage = "All fields are required"
                    }
                    else if password != confirmPassword {
                        errorMessage = "Passwords do not match"
                    }
                    else{
                        Auth.auth().createUser(withEmail: username, password: password) { result, error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            }
                            else{
                                withAnimation{
                                    isPresented = false
                                    username = ""
                                    password = ""
                                    confirmPassword = ""
                                    errorMessage = nil
                                }
                                
                            }
                            
                        }
                       
                    }
                    
                    
                }
                    .foregroundColor(.blue)
                }
            .onDisappear{
                username = ""
                password = ""
                confirmPassword = ""
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



