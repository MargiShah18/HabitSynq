//
//  ContentView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-27.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingLoginScreen = false
    @State private var showingSignupScreen = false
    @State private var isAuthenticated = false
   
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0.3))
                
                VStack(spacing:8){
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120,height: 120)
    
                    Text("HabitSynq")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("Personal Goals·Social Momentum")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                }.offset(y:-120)
                
                VStack{
                    HStack(spacing:50){
                        BouncyButton(title:"Log In", action: logIn)
                        
                        BouncyButton(title:"Sign Up", action: signUp)
                        
                    }
                    .buttonStyle(.bordered)
                    .offset(y:50)
                    
                }
                if showingLoginScreen{
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture{ withAnimation {showingLoginScreen = false}}
                        .transition(.opacity)
                        .zIndex(1)
                    LoginPopover(
                        isPresented: $showingLoginScreen,
                        username: $username,
                        password: $password,
                        didLogIn: {
                            isAuthenticated = true
                        }
                    )
                    .zIndex(2)
                    .transition(.scale)
                }
                
                if showingSignupScreen{
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture{ withAnimation {showingSignupScreen = false}}
                        .transition(.opacity)
                        .zIndex(1)
                    SignupPopover(
                        isPresented: $showingSignupScreen,
                        username: $username,
                        password: $password,
                        confirmPassword : $confirmPassword
                    )
                    .zIndex(2)
                    .transition(.scale)
                }
                
            }
            .fullScreenCover(isPresented : $isAuthenticated){
                LoggedInHomeView()
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut, value: showingLoginScreen)
    }
    
    
    private func logIn(){
        //To Do: Create a login button function
        withAnimation{
            showingLoginScreen =  true
        }
    }
    private func signUp(){
        //To DO : Create signin function
        withAnimation {
            showingSignupScreen = true
        }
    }
}

    

    


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
