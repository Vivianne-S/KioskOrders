//
//  LoginView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    @State private var buttonPressed = false

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                // HEADER
                ZStack {
                    LinearGradient(colors: [.pink, .purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 180)
                        .cornerRadius(30)
                        .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 5)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "cart.fill")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(.yellow)
                        Text("KioskOrders")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Text("Logga in för att handla")
                            .foregroundColor(.yellow.opacity(0.8))
                    }
                }
                .padding(.horizontal)
                
                // FORM
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(LinearGradient(colors: [.pink.opacity(0.2), .yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Lösenord", text: $password)
                        .padding()
                        .background(LinearGradient(colors: [.purple.opacity(0.2), .orange.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleLogin) {
                        Text(authVM.isLoading ? "Laddar..." : "Logga in")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.pink, .purple, .orange], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                            .scaleEffect(buttonPressed ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: buttonPressed)
                    }
                    .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                        buttonPressed = pressing
                    }, perform: {})
                }
                .padding(.horizontal)
                
                // SIGN UP LINK
                Button("Inget konto? Skapa konto här") {
                    showingSignUp = true
                }
                .foregroundColor(.orange)
                .padding(.top)
                
                Spacer()
            }
            .padding(.top)
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
    }
    
    private func handleLogin() {
        authVM.signIn(email: email, password: password)
    }
}
