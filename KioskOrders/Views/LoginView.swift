//
//  LoginView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                // HEADER
                ZStack {
                    LinearGradient(colors: [.pink, .purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 180)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                    
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
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(5)
                    
                    SecureField("Lösenord", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleLogin) {
                        Text(authVM.isLoading ? "Laddar..." : "Logga in")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .disabled(authVM.isLoading || email.isEmpty || password.isEmpty)
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
