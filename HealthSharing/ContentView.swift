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
    @State private var showSignupSuccess = false

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

                // Login Popover
                if showingLoginScreen {
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
                
                // Signup Popover with new binding for toast
                if showingSignupScreen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture{ withAnimation {showingSignupScreen = false}}
                        .transition(.opacity)
                        .zIndex(1)
                    SignupPopover(
                        isPresented: $showingSignupScreen,
                        username: $username,
                        password: $password,
                        confirmPassword : $confirmPassword,
                        showSignupSuccess: $showSignupSuccess
                    )
                    .zIndex(2)
                    .transition(.scale)
                }
                
                // toast
                if showSignupSuccess {
                    VStack {
                        SignupSuccessToast(isVisible: $showSignupSuccess)
                            .padding(.top, 40) 
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .zIndex(100)
                }

            }
            .fullScreenCover(isPresented : $isAuthenticated){
                MainTabView(isAuthenticated: $isAuthenticated)
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut, value: showingLoginScreen)
    }
    
    private func logIn(){
        withAnimation{
            showingLoginScreen = true
        }
    }
    private func signUp(){
        withAnimation {
            showingSignupScreen = true
        }
    }
}


struct SignupSuccessToast: View {
    @Binding var isVisible: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Account Created")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                Text("You can log in now.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.93))
            }
            Spacer()
            Button(action: {
                withAnimation { isVisible = false }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(8)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.18), radius: 10, y: 2)
        .padding(.top, 70)
        .padding(.horizontal, 32)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation { isVisible = false }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
