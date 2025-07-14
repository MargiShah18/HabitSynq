   //
    //  SettingsView.swift
    //  HealthSharing
    //
    //  Created by Margi Shah on 2025-07-04.
    //

    import Foundation
    import SwiftUI
    import FirebaseAuth
    import FirebaseFirestore

    struct SettingsView: View {
        @Binding var isAuthenticated: Bool
        @State private var showNamePopover = false
        @State private var showEmailPopover = false
        @State private var showPasswordPopover = false
        @State private var showQRPopover = false
        @State private var showDeleteAlert = false
        @State private var showReviewPopover = false
        
        @State private var newName: String = ""
        @State private var newEmail: String = ""
        @State private var newPassword: String = ""
        @State private var userEmail: String = ""
        @State private var userDisplayName: String = ""
        @State private var confirmPassword: String = ""
        @State private var reviewRating = 0
        
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
                        .popover(
                            isPresented: $showNamePopover,
                            attachmentAnchor: .rect(.bounds),
                            arrowEdge: .trailing
                        ) {
                            VStack(spacing: 16){
                                Text("Edit Name").font(.headline)
                                TextField("Name", text: $newName).textFieldStyle(.roundedBorder)
                                Button("Save"){
                                    updateName()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                            .frame(width: 260)
                            
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
                            newPassword = ""
                            confirmPassword = ""
                            showPasswordPopover = true
                        } label: {
                            Label("Reset Password", systemImage: "lock")
                        }
                        .popover(isPresented: $showPasswordPopover) {
                            VStack(spacing: 16){
                                Text("Reset Password").font(.headline)
                                SecureField("New Password", text: $newPassword).textFieldStyle(.roundedBorder)
                                SecureField("Confirm Password", text: $confirmPassword).textFieldStyle(.roundedBorder)
                                if !confirmPassword.isEmpty && confirmPassword != newPassword {
                                    Text("Passwords do not match").foregroundColor(.red)
                                        .font(.caption)
                                }
                                Button("Save"){
                                    updatePassword()
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(newPassword.isEmpty || confirmPassword.isEmpty || confirmPassword != newPassword)
                            }
                            .padding()
                            .frame(width: 280)
                        }
                        // QR Code Button
                        Button {
                            showQRPopover = true
                        } label: {
                            HStack {
                                Label("QR Code", systemImage: "qrcode")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .popover(isPresented: $showQRPopover) {
                            VStack(spacing: 16) {
                                Text("Scan to Add Me!").font(.headline)
                                QRCodeView(dataString: userEmail)
                                    .frame(width: 200, height: 200)
                                Text(userEmail)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(16)
                            .frame(width: 250)
                        }
                        
                    }
                    
                    Section {
                        Button(action: {
                            do{
                                try Auth.auth().signOut()
                                isAuthenticated = false
                            }catch{
                                print("Error Signing out: \(error.localizedDescription)")
                            }
                        }) {
                            Label("Sign Out", systemImage: "arrowshape.turn.up.left")
                                .foregroundColor(.red)
                        }
                    }
                    Section {
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Label("Delete Account", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showDeleteAlert){
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete your account? This cannot be undone."),
                                primaryButton: .destructive(Text("Delete")){
                                    performDeleteAccount()
                                },
                                secondaryButton: .cancel()
                                
                            )
                        }
                    }
                }
                .padding(.bottom,4)
                Spacer(minLength: 0)
                
                
            }
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
        private func performDeleteAccount() {
            guard let user = Auth.auth().currentUser else {return}
            let userId = user.uid
            let db = Firestore.firestore()
            
            let batch = db.batch()
            db.collection("habits").whereField("userId", isEqualTo: userId).getDocuments {snapshot, error in
                if let docs = snapshot?.documents{
                    for doc in docs{
                        batch.deleteDocument(doc.reference)
                    }
                }
                // Optionally: if you have a "users" collection
                batch.deleteDocument(db.collection("users").document(userId))
                
                batch.commit{ batchError in
                        if let batchError = batchError{
                            print("Error deleting Firestore data: \(batchError.localizedDescription)")
                            return
                    }
                    
                    user.delete{ authError in
                            if let authError = authError{
                            print("Error deleting user: \(authError.localizedDescription)")
                        }
                        else{
                            isAuthenticated = false
                        }
                    }
                }
            }
        }
       
        
    }
            
        


