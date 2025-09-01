//
//  SignUpView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    
    var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && passwordsMatch && !name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Skapa konto")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.pink)
                
                VStack(spacing: 15) {
                    TextField("Namn", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Lösenord", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Bekräfta lösenord", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    if !confirmPassword.isEmpty && !passwordsMatch {
                        Text("Lösenorden matchar inte")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleSignUp) {
                        Text(authVM.isLoading ? "Laddar..." : "Skapa konto")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .disabled(!isFormValid || authVM.isLoading)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Avbryt") {
                    dismiss()
                }
                .foregroundColor(.purple)
                .padding(.bottom)
            }
        }
    }
    
    private func handleSignUp() {
        authVM.signUp(email: email, password: password, name: name)
    }
}
