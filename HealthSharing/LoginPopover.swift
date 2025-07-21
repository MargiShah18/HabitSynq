import SwiftUI
import FirebaseAuth

struct LoginPopover: View {
    @Binding var isPresented: Bool
    @Binding var username: String
    @Binding var password: String
    var  didLogIn: () -> Void
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Log In")
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding(.bottom, 4)

            // Username Field (white box)
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

            // Password Field (white box)
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

            // Error
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, -6)
            }

            // Button row
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
                    Auth.auth().signIn(withEmail: username, password: password) { result, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            withAnimation {
                                isPresented = false
                                username = ""
                                password = ""
                                errorMessage = nil
                                didLogIn()
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
            errorMessage = nil
        }
    }
}
