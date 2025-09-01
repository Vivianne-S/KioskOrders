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
            Form {
                Section("Personlig information") {
                    TextField("Namn", text: $name)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Lösenord", text: $password)
                    SecureField("Bekräfta lösenord", text: $confirmPassword)
                    
                    if !confirmPassword.isEmpty && !passwordsMatch {
                        Text("Lösenorden matchar inte")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                if let error = authVM.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: handleSignUp) {
                        if authVM.isLoading {
                            ProgressView()
                        } else {
                            Text("Skapa konto")
                        }
                    }
                    .disabled(!isFormValid || authVM.isLoading)
                }
            }
            .navigationTitle("Skapa konto")
            .navigationBarItems(trailing: Button("Avbryt") {
                dismiss()
            })
        }
    }
    
    private func handleSignUp() {
        authVM.signUp(email: email, password: password, name: name)
    }
}