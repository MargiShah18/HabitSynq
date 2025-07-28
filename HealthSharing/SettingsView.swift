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
        @State private var showNameSheet = false
        @State private var showEmailSheet = false
        @State private var showPasswordSheet = false
        @State private var showQRSheet = false
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
                            showNameSheet = true
                        } label: {
                            HStack{
                                Label("Name", systemImage: "person")
                                Spacer()
                                Text(userName)
                                    .foregroundColor(.gray)
                            }
                        }
                        .sheet(isPresented: $showNameSheet) {
                            EditNameSheet(
                                currentName: userName,
                                onSave: { name in
                                    newName = name
                                    updateName()
                                }
                            )
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.visible)
                        }
                        
                        //Email
                        Button{
                            newEmail = userEmail
                            showEmailSheet = true
                        } label: {
                            HStack{
                                Label("Email", systemImage: "envelope")
                                Spacer()
                                Text(userEmail)
                                    .foregroundColor(.gray)
                            }
                        }
                        .sheet(isPresented: $showEmailSheet) {
                            EditEmailSheet(
                                currentEmail: userEmail,
                                onSave: { email in
                                    newEmail = email
                                    updateEmail()
                                }
                            )
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.visible)
                        }
                        
                        //Password
                        Button{
                            newPassword = ""
                            confirmPassword = ""
                            showPasswordSheet = true
                        } label: {
                            Label("Reset Password", systemImage: "lock")
                        }
                        .sheet(isPresented: $showPasswordSheet) {
                            EditPasswordSheet(
                                onSave: { password in
                                    newPassword = password
                                    updatePassword()
                                }
                            )
                            .presentationDetents([.height(380)])
                            .presentationDragIndicator(.visible)
                            }
                        
                        // QR Code Button
                        Button {
                            showQRSheet = true
                        } label: {
                            HStack {
                                Label("QR Code", systemImage: "qrcode")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .sheet(isPresented: $showQRSheet) {
                            QRCodeSheet(userEmail: userEmail)
                                .presentationDetents([.height(400)])
                                .presentationDragIndicator(.visible)
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
                    showNameSheet = false
                }
            }
        }
        private func updateEmail() {
            guard let user = Auth.auth().currentUser else {return}
            user.updateEmail(to: newEmail){error in
                if error == nil{
                    userEmail = newEmail
                    showEmailSheet = false
                }
            }
        }
        private func updatePassword() {
            guard let user = Auth.auth().currentUser else {return}
            user.updatePassword(to: newPassword){error in
                if error == nil{
                    showPasswordSheet = false
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

    // MARK: - Modern Edit Sheets

    struct EditNameSheet: View {
        let currentName: String
        let onSave: (String) -> Void
        
        @State private var name: String = ""
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 6)
                        .padding(.top, 12)
                    
                    Text("Edit Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                }
                
                // Content
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Display Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your name", text: $name)
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: name.isEmpty ? 0 : 1)
                            )
                    }
                    
                    Button(action: {
                        onSave(name)
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(name.isEmpty ? Color.gray : Color.blue)
                            )
                    }
                    .disabled(name.isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .onAppear {
                name = currentName
            }
        }
    }

    struct EditEmailSheet: View {
        let currentEmail: String
        let onSave: (String) -> Void
        
        @State private var email: String = ""
        @Environment(\.dismiss) private var dismiss
        
        var isValidEmail: Bool {
            email.contains("@") && email.contains(".")
        }
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 6)
                        .padding(.top, 12)
                    
                    Text("Edit Email")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                }
                
                // Content
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your email", text: $email)
                            .font(.body)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isValidEmail ? Color.blue.opacity(0.3) : Color.red.opacity(0.3), lineWidth: email.isEmpty ? 0 : 1)
                            )
                        
                        if !email.isEmpty && !isValidEmail {
                            Text("Please enter a valid email address")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        onSave(email)
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill((!email.isEmpty && isValidEmail) ? Color.blue : Color.gray)
                            )
                    }
                    .disabled(email.isEmpty || !isValidEmail)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .onAppear {
                email = currentEmail
            }
        }
    }

    struct EditPasswordSheet: View {
        let onSave: (String) -> Void
        
        @State private var newPassword: String = ""
        @State private var confirmPassword: String = ""
        @Environment(\.dismiss) private var dismiss
        
        var passwordsMatch: Bool {
            !confirmPassword.isEmpty && newPassword == confirmPassword
        }
        
        var isValidPassword: Bool {
            newPassword.count >= 6
        }
        
        var canSave: Bool {
            isValidPassword && passwordsMatch
        }
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 6)
                        .padding(.top, 12)
                    
                    Text("Reset Password")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                }
                
                // Content
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        // New Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            SecureField("Enter new password", text: $newPassword)
                                .font(.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            newPassword.isEmpty ? Color.clear :
                                            isValidPassword ? Color.blue.opacity(0.3) : Color.red.opacity(0.3),
                                            lineWidth: 1
                                        )
                                )
                            
                            if !newPassword.isEmpty && !isValidPassword {
                                Text("Password must be at least 6 characters")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            SecureField("Confirm new password", text: $confirmPassword)
                                .font(.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            confirmPassword.isEmpty ? Color.clear :
                                            passwordsMatch ? Color.blue.opacity(0.3) : Color.red.opacity(0.3),
                                            lineWidth: 1
                                        )
                                )
                            
                            if !confirmPassword.isEmpty && !passwordsMatch {
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button(action: {
                        onSave(newPassword)
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(canSave ? Color.blue : Color.gray)
                            )
                    }
                    .disabled(!canSave)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
    }

    struct QRCodeSheet: View {
        let userEmail: String
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 6)
                        .padding(.top, 12)
                    
                    Text("My QR Code")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                }
                
                // Content
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Scan to Add Me!")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        QRCodeView(dataString: userEmail)
                            .frame(width: 200, height: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            )
                        
                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
    }
            
        


