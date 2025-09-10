//
//  SignUpView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var buttonPressed = false
    @State private var makeEmployee = false   // 👩‍🍳 admin kan välja detta

    @State private var kiosks: [String] = []       // alla kioskId:n
    @State private var selectedKiosk: String = ""  // vald kiosk

    private let db = Firestore.firestore()

    private var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && passwordsMatch && !name.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // HEADER
                Text("Skapa konto")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.pink)

                // FORM
                VStack(spacing: 15) {
                    TextField("Namn", text: $name)
                        .padding()
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(10)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Lösenord", text: $password)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Bekräfta lösenord", text: $confirmPassword)
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(10)

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

                    // 👩‍🍳 Visa bara för admin
                    if authVM.currentUser?.email == "admin@admin.se" {
                        Toggle("Registrera som anställd", isOn: $makeEmployee)
                            .padding()

                        if makeEmployee {
                            Picker("Välj kiosk", selection: $selectedKiosk) {
                                ForEach(kiosks, id: \.self) { kiosk in
                                    Text(kiosk).tag(kiosk)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .onAppear {
                                loadKiosks()
                            }
                        }
                    }

                    Button(action: handleSignUp) {
                        Text(authVM.isLoading ? "Laddar..." : "Skapa konto")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .scaleEffect(buttonPressed ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5),
                                       value: buttonPressed)
                    }
                    .disabled(!isFormValid || authVM.isLoading)
                    .onLongPressGesture(minimumDuration: 0.01,
                                        pressing: { pressing in
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

        // 🔐 Om admin markerat "Registrera som anställd"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if makeEmployee,
               let uid = authVM.currentUser?.uid,
               !selectedKiosk.isEmpty {
                db.collection("employees").document(uid).setData([
                    "kioskId": selectedKiosk,
                    "role": "employee"
                ]) { err in
                    if let err = err {
                        print("❌ Kunde inte skapa employee: \(err.localizedDescription)")
                    } else {
                        print("✅ Employee-dokument skapat för \(uid) → kiosk=\(selectedKiosk)")
                    }
                }
            }
        }
    }

    private func loadKiosks() {
        db.collection("kiosk").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Kunde inte hämta kiosker: \(error.localizedDescription)")
                return
            }
            self.kiosks = snapshot?.documents.compactMap { $0.documentID } ?? []
            if let first = self.kiosks.first {
                self.selectedKiosk = first
            }
        }
    }
}
