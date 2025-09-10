//
//  AdminDashboardView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-08.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AdminDashboardView: View {
    @State private var kiosks: [String] = []
    @State private var newKioskName = ""

    @State private var employeeEmail = ""
    @State private var employeePassword = ""
    @State private var employeeName = ""
    @State private var selectedKiosk: String = ""

    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("👑 Adminpanel")
                        .font(.largeTitle)
                        .bold()

                    // ➕ Skapa kiosk
                    VStack(spacing: 12) {
                        Text("➕ Lägg till kiosk")
                            .font(.headline)

                        HStack {
                            TextField("Kiosk-namn", text: $newKioskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Spara") { addKiosk() }
                                .buttonStyle(.borderedProminent)
                        }

                        // Lista kiosker
                        if !kiosks.isEmpty {
                            VStack(alignment: .leading) {
                                Text("📋 Befintliga kiosker:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ForEach(kiosks, id: \.self) { kiosk in
                                    Text("• \(kiosk)")
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(12)

                    // 👩‍🍳 Skapa anställd
                    VStack(spacing: 12) {
                        Text("👩‍🍳 Skapa anställd")
                            .font(.headline)

                        TextField("Namn", text: $employeeName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Email", text: $employeeEmail)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Lösenord", text: $employeePassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        if !kiosks.isEmpty {
                            Picker("Välj kiosk", selection: $selectedKiosk) {
                                ForEach(kiosks, id: \.self) { kiosk in
                                    Text(kiosk).tag(kiosk)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }

                        Button("Skapa anställd") {
                            createEmployee()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .onAppear { loadKiosks() }
            .navigationTitle("Adminpanel")
        }
    }

    // 🔹 Lägg till kiosk
    private func addKiosk() {
        guard !newKioskName.isEmpty else { return }
        db.collection("kiosk").document(newKioskName).setData([
            "createdAt": Timestamp()
        ]) { err in
            if let err = err {
                print("❌ Kunde inte skapa kiosk: \(err.localizedDescription)")
            } else {
                print("✅ Ny kiosk '\(newKioskName)' skapad")
                newKioskName = ""
                loadKiosks()
            }
        }
    }

    // 🔹 Ladda kiosker
    private func loadKiosks() {
        db.collection("kiosk").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Kunde inte hämta kiosker: \(error.localizedDescription)")
                return
            }
            kiosks = snapshot?.documents.map { $0.documentID } ?? []
            if selectedKiosk.isEmpty, let first = kiosks.first {
                selectedKiosk = first
            }
        }
    }

    // 🔹 Skapa anställd
    private func createEmployee() {
        guard !employeeEmail.isEmpty, !employeePassword.isEmpty, !employeeName.isEmpty, !selectedKiosk.isEmpty else {
            print("❌ Alla fält måste fyllas i")
            return
        }

        // ⚠️ Viktigt: detta funkar bara om du kör med Firebase Admin SDK i backend
        // men för test kan vi skapa konto direkt i Auth via createUserWithEmail
        Auth.auth().createUser(withEmail: employeeEmail, password: employeePassword) { result, error in
            if let error = error {
                print("❌ Kunde inte skapa användare: \(error.localizedDescription)")
                return
            }
            guard let uid = result?.user.uid else { return }

            // Lägg in i employees
            db.collection("employees").document(uid).setData([
                "kioskId": selectedKiosk,
                "name": employeeName,
                "role": "employee"
            ]) { err in
                if let err = err {
                    print("❌ Kunde inte spara employee: \(err.localizedDescription)")
                } else {
                    print("✅ Anställd skapad: \(employeeName) → kiosk=\(selectedKiosk)")
                    employeeName = ""
                    employeeEmail = ""
                    employeePassword = ""
                }
            }
        }
    }
}
