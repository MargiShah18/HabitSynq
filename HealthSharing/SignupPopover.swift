import SwiftUI
import FirebaseAuth

struct SignupPopover: View {
    @Binding var isPresented: Bool
    @Binding var username: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var showSignupSuccess: Bool  

    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding(.bottom, 4)

            // Username Field (white)
            TextField("Username", text: $username)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                )
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 8)

            // Password Field (white)
            SecureField("Password", text: $password)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                )
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 8)

            // Confirm Password Field (white)
            SecureField("Confirm Password", text: $confirmPassword)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                )
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 8)

            // Error
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, -6)
            }

            // Buttons row
            HStack(spacing: 18) {
                Button(action: {
                    withAnimation { isPresented = false }
                }) {
                    Text("Cancel")
                        .fontWeight(.medium)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.white.opacity(0.09))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        errorMessage = "All fields are required"
                    }
                    else if password != confirmPassword {
                        errorMessage = "Passwords do not match"
                    }
                    else {
                        Auth.auth().createUser(withEmail: username, password: password) { result, error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            }
                            else {
                                withAnimation {
                                    isPresented = false
                                    username = ""
                                    password = ""
                                    confirmPassword = ""
                                    errorMessage = nil
                                    showSignupSuccess = true     // <-- Show toast!
                                }
                            }
                        }
                    }
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.84), Color.cyan.opacity(0.85)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.12), radius: 3, y: 1)
                }
            }
            .padding(.top, 2)
            .padding(.horizontal, 2)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.13), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 20, y: 7)
        .frame(maxWidth: 355)
        .transition(.scale)
        .onDisappear {
            username = ""
            password = ""
            confirmPassword = ""
            errorMessage = nil
        }
    }
}
