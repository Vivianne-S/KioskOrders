//
//  AuthenticationViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isAdmin = false
    @Published var isEmployee = false
    @Published var employeeKioskId: String? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    init() { setupAuthListener() }

    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // 🔐 Listener för login-status
    private func setupAuthListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.resetState()
                self?.isAuthenticated = user != nil
                self?.currentUser = user
                print("🔐 Auth status: \(user != nil ? "Inloggad" : "Utloggad")")

                if let user = user {
                    self?.checkClaimsAndRole(user: user)
                }
            }
        }
    }

    private func resetState() {
        isAdmin = false
        isEmployee = false
        employeeKioskId = nil
    }

    private func checkClaimsAndRole(user: User) {
        user.getIDTokenResult(completion: { [weak self] result, error in
            if let error = error {
                print("❌ Token error: \(error.localizedDescription)")
                self?.checkIfEmployee(userId: user.uid)
                return
            }
            if let claims = result?.claims {
                print("🔑 Custom claims: \(claims)")
                if let isAdmin = claims["admin"] as? Bool, isAdmin {
                    DispatchQueue.main.async {
                        self?.isAdmin = true
                    }
                    print("👑 Inloggad som admin")
                    return
                }
            }
            // annars kolla employee
            self?.checkIfEmployee(userId: user.uid)
        })
    }

    // 👩‍🍳 Kontrollera om användare är anställd
    private func checkIfEmployee(userId: String) {
        db.collection("employees").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("❌ Fel vid hämtning av employee-roll: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                DispatchQueue.main.async {
                    self?.isEmployee = false
                    self?.employeeKioskId = nil
                    print("🧑 Inloggad som vanlig kund")
                }
                return
            }

            let role = data["role"] as? String ?? "customer"
            let kioskId = data["kioskId"] as? String

            DispatchQueue.main.async {
                if role == "employee" {
                    self?.isEmployee = true
                    self?.employeeKioskId = kioskId
                    print("👩‍🍳 Inloggad som employee för kiosk \(kioskId ?? "-")")
                } else {
                    self?.isEmployee = false
                    self?.employeeKioskId = nil
                    print("🧑 Inloggad som vanlig kund (role=\(role))")
                }
            }
        }
    }

    // 🚪 Logga ut
    func signOut() {
        do {
            try Auth.auth().signOut()
            resetState()
            isAuthenticated = false
            currentUser = nil
            print("✅ Utloggad")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Utloggningsfel: \(error.localizedDescription)")
        }
    }

    // 🔑 Logga in
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("❌ Inloggningsfel: \(error.localizedDescription)")
                    return
                }
                if let user = result?.user {
                    self?.isAuthenticated = true
                    self?.currentUser = user
                    self?.checkClaimsAndRole(user: user)
                    print("✅ Inloggad som \(user.email ?? "-")")
                }
            }
        }
    }

    // 🆕 Registrera nytt konto
    func signUp(email: String, password: String, name: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("❌ Registreringsfel: \(error.localizedDescription)")
                    return
                }
                guard let user = result?.user else { return }

                let change = user.createProfileChangeRequest()
                change.displayName = name
                change.commitChanges { err in
                    if let err = err {
                        self?.errorMessage = err.localizedDescription
                        print("❌ Namnfel: \(err.localizedDescription)")
                        return
                    }
                    self?.isAuthenticated = true
                    self?.currentUser = user
                    print("✅ Registrerad som \(name) (\(user.email ?? "-"))")
                }
            }
        }
    }
}
