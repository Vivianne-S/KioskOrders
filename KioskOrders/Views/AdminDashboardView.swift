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
    @State private var kiosks: [Kiosk] = []
    @State private var newKioskName = ""

    @State private var employeeEmail = ""
    @State private var employeePassword = ""
    @State private var employeeName = ""
    @State private var selectedKioskId: String = ""

    @State private var foodName = ""
    @State private var foodPrice = ""
    @State private var foodPrepTime = ""
    @State private var selectedFoodKiosks: Set<String> = []

    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Text("👑 Adminpanel")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(AppGradients.candyPurple)
                        .shimmer()

                    // 📂 Menykort
                    VStack(spacing: 20) {
                        menuCard(
                            title: "🍭 Kiosker",
                            description: "Hantera kiosker i parken",
                            gradient: AppGradients.cardGradient,
                            destination: AnyView(kioskSectionView)
                        )

                        menuCard(
                            title: "👩‍🍳 Anställda",
                            description: "Lägg till personal",
                            gradient: AppGradients.fabGradient,
                            destination: AnyView(employeeSectionView)
                        )

                        menuCard(
                            title: "🍫 Produkter",
                            description: "Hantera snacks & dryck",
                            gradient: AppGradients.background,
                            destination: AnyView(foodItemSectionView)
                        )
                    }
                }
                .padding()
            }
            .onAppear { loadKiosks() }
            .background(AppGradients.background.ignoresSafeArea())
            .navigationTitle("Adminpanel")
        }
    }

    // MARK: - Menykort
    private func menuCard(title: String, description: String, gradient: LinearGradient, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(gradient)
                    .frame(height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .padding(.horizontal)
            .shimmer()
        }
    }

    // MARK: - KioskView
    private var kioskSectionView: some View {
        VStack(spacing: 12) {
            Text("➕ Lägg till kiosk")
                .font(.headline)

            HStack {
                TextField("Kiosk-namn", text: $newKioskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Spara") { addKiosk() }
                    .buttonStyle(.borderedProminent)
            }

            if !kiosks.isEmpty {
                List(kiosks) { kiosk in
                    NavigationLink(destination: FoodManagerView(kiosk: kiosk)) {
                        HStack {
                            Text(kiosk.name)
                                .foregroundColor(AppGradients.candyPurple)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .background(AppGradients.background.ignoresSafeArea())
    }

    // MARK: - EmployeeView
    private var employeeSectionView: some View {
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
                Picker("Välj kiosk", selection: $selectedKioskId) {
                    ForEach(kiosks) { kiosk in
                        Text(kiosk.name).tag(kiosk.id ?? "")
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
        .background(AppGradients.background.ignoresSafeArea())
    }

    // MARK: - FoodItemView
    private var foodItemSectionView: some View {
        VStack(spacing: 12) {
            Text("🍫 Lägg till Food Item")
                .font(.headline)

            TextField("Namn på vara", text: $foodName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Pris (kr)", text: $foodPrice)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Tillagningstid (minuter)", text: $foodPrepTime)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            VStack(alignment: .leading, spacing: 6) {
                Text("Välj kiosker:")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ForEach(kiosks) { kiosk in
                    HStack {
                        Image(systemName: selectedFoodKiosks.contains(kiosk.id ?? "")
                              ? "checkmark.square.fill" : "square")
                            .foregroundColor(AppGradients.candyPink)
                        Text(kiosk.name)
                            .onTapGesture {
                                if let id = kiosk.id {
                                    if selectedFoodKiosks.contains(id) {
                                        selectedFoodKiosks.remove(id)
                                    } else {
                                        selectedFoodKiosks.insert(id)
                                    }
                                }
                            }
                    }
                }
            }

            Button("Spara vara") {
                addFoodItem()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(AppGradients.background.ignoresSafeArea())
    }

    // MARK: - Firestore functions
    private func addKiosk() {
        guard !newKioskName.isEmpty else { return }
        db.collection("kiosk").document(newKioskName).setData([
            "name": newKioskName,
            "description": "Ny kiosk i parken",
            "category": "Snacks",
            "isActive": true,
            "waitTime": 5,
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

    private func loadKiosks() {
        db.collection("kiosk").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Kunde inte hämta kiosker: \(error.localizedDescription)")
                return
            }
            kiosks = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Kiosk.self)
            } ?? []
            if selectedKioskId.isEmpty, let first = kiosks.first?.id {
                selectedKioskId = first
            }
        }
    }

    private func createEmployee() {
        guard !employeeEmail.isEmpty, !employeePassword.isEmpty, !employeeName.isEmpty, !selectedKioskId.isEmpty else {
            print("❌ Alla fält måste fyllas i")
            return
        }

        Auth.auth().createUser(withEmail: employeeEmail, password: employeePassword) { result, error in
            if let error = error {
                print("❌ Kunde inte skapa användare: \(error.localizedDescription)")
                return
            }
            guard let uid = result?.user.uid else { return }

            db.collection("employees").document(uid).setData([
                "kioskId": selectedKioskId,
                "name": employeeName,
                "role": "employee"
            ]) { err in
                if let err = err {
                    print("❌ Kunde inte spara employee: \(err.localizedDescription)")
                } else {
                    print("✅ Anställd skapad: \(employeeName) → kiosk=\(selectedKioskId)")
                    employeeName = ""
                    employeeEmail = ""
                    employeePassword = ""
                }
            }
        }
    }

    private func addFoodItem() {
    guard !foodName.isEmpty,
          let price = Double(foodPrice),
          let prep = Int(foodPrepTime),
          !selectedFoodKiosks.isEmpty else {
        print("❌ Alla fält måste fyllas i")
        return
    }

    let data: [String: Any] = [
        "name": foodName,
        "description": "", // 👈 lägg alltid till
        "category": "Snacks", // 👈 lägg alltid till
        "price": price,
        "preparationTime": prep,
        "isAvailable": true,
        "availableAt": Array(selectedFoodKiosks)
    ]

    db.collection("fooditems").addDocument(data: data) { err in
        if let err = err {
            print("❌ Kunde inte spara food item: \(err.localizedDescription)")
        } else {
            print("✅ Food item '\(foodName)' sparad för kiosker=\(selectedFoodKiosks)")
            foodName = ""
            foodPrice = ""
            foodPrepTime = ""
            selectedFoodKiosks.removeAll()
        }
    }
}
    }

