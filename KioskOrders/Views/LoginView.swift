import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 60, height: 50)
                        .foregroundColor(.blue)
                    Text("KioskOrders")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Logga in för att handla")
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                // Form
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    
                    SecureField("Lösenord", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleLogin) {
                        if authVM.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Logga in")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(authVM.isLoading || email.isEmpty || password.isEmpty)
                    .padding(.top)
                }
                .padding(.horizontal)
                
                // Sign up link
                Button("Inget konto? Skapa konto här") {
                    showingSignUp = true
                }
                .foregroundColor(.blue)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
    }
    
    private func handleLogin() {
        authVM.signIn(email: email, password: password)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}