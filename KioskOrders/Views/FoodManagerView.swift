//
//  FoodManagerView.swift
//  KioskOrders
//

import SwiftUI
import FirebaseFirestore


struct FoodManagerView: View {
    let kiosk: Kiosk
    @State private var foodItems: [FoodItem] = []
    @State private var isLoading = true
    @State private var editingItem: FoodItem? = nil
    @State private var selectedFilter: String = "Alla"

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // 👇 internal init funkar direkt
    init(kiosk: Kiosk) {
        self.kiosk = kiosk
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🍬 Hantera varor för \(kiosk.name)")
                .font(.title2)
                .bold()
                .foregroundColor(AppGradients.candyPurple)
                .padding(.bottom, 8)


            // 🔎 Filter meny
            Picker("Filter", selection: $selectedFilter) {
                Text("Alla").tag("Alla")
                Text("Tillgängliga").tag("Tillgängliga")
                Text("Slut").tag("Slut")
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 6)

            if isLoading {
                ProgressView("Laddar varor...")
                    .tint(AppGradients.candyPink)
            } else if filteredItems.isEmpty {
                Text("Inga varor matchar filter.")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(filteredItems) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text("\(Int(item.price)) kr • \(item.preparationTime) min")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Kiosker: \(item.availableAt.joined(separator: ", "))")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                // ✅ Tillgänglighet toggle
                                Button {
                                    toggleAvailability(item)
                                } label: {
                                    Circle()
                                        .fill(item.isAvailable ? Color.green : Color.red)
                                        .frame(width: 28, height: 28)
                                        .overlay(
                                            Image(systemName: item.isAvailable ? "checkmark" : "xmark")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        )
                                        .shimmer()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                        // 📝 Redigera
                        .onTapGesture {
                            editingItem = item
                        }
                    }
                    // 🗑️ Radera
                    .onDelete { indexSet in
                        indexSet.forEach { deleteItem(foodItems[$0]) }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .onAppear { listenForFoodItems() }
        .onDisappear { listener?.remove() }
        .background(AppGradients.background.ignoresSafeArea())
        // 📝 Sheet för redigering
        .sheet(item: $editingItem) { item in
            EditFoodItemSheet(item: item) { updated in
                updateItem(updated)
            }
        }
    }

    // MARK: - Filter
    private var filteredItems: [FoodItem] {
        switch selectedFilter {
        case "Tillgängliga": return foodItems.filter { $0.isAvailable }
        case "Slut": return foodItems.filter { !$0.isAvailable }
        default: return foodItems
        }
    }

    // MARK: - Firestore
    private func listenForFoodItems() {
        db.collection("fooditems")
            .whereField("availableAt", arrayContains: kiosk.id ?? "")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Kunde inte hämta fooditems: \(error.localizedDescription)")
                    return
                }
                self.foodItems = snapshot?.documents.compactMap {
                    try? $0.data(as: FoodItem.self)
                } ?? []
                self.isLoading = false
            }
    }

    private func toggleAvailability(_ item: FoodItem) {
        guard let id = item.id else { return }
        db.collection("fooditems").document(id).updateData([
            "isAvailable": !item.isAvailable
        ])
    }

    private func deleteItem(_ item: FoodItem) {
        guard let id = item.id else { return }
        db.collection("fooditems").document(id).delete()
    }

    private func updateItem(_ updated: FoodItem) {
        guard let id = updated.id else { return }
        do {
            try db.collection("fooditems").document(id).setData(from: updated)
        } catch {
            print("❌ Kunde inte uppdatera fooditem: \(error.localizedDescription)")
        }
    }
}
