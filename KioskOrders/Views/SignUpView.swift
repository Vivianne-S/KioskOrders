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
    @State private var buttonPressed = false
    
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
                        .padding()
                        .background(LinearGradient(colors: [.pink.opacity(0.2), .yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(LinearGradient(colors: [.purple.opacity(0.2), .orange.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Lösenord", text: $password)
                        .padding()
                        .background(LinearGradient(colors: [.pink.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                    
                    SecureField("Bekräfta lösenord", text: $confirmPassword)
                        .padding()
                        .background(LinearGradient(colors: [.orange.opacity(0.2), .yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                    
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
                            .background(LinearGradient(colors: [.pink, .purple, .orange], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                            .scaleEffect(buttonPressed ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: buttonPressed)
                    }
                    .disabled(!isFormValid || authVM.isLoading)
                    .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                        buttonPressed = pressing
                    }, perform: {})
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
