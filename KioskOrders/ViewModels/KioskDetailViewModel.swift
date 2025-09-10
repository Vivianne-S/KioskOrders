//
//  KioskDetailViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import Foundation
import FirebaseFirestore

@MainActor
class KioskDetailViewModel: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var pressedItemId: String?

    private let db = Firestore.firestore()

    // ✅ Nu tar vi hela Kiosk som parameter
    func fetchFoodItems(for kiosk: Kiosk) {
        guard let kioskId = kiosk.id else {
            self.errorMessage = "Kiosk saknar ID"
            return
        }

        isLoading = true
        errorMessage = nil

        db.collection("fooditems")
            .whereField("availableAt", arrayContains: kioskId)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = "Fel vid hämtning: \(error.localizedDescription)"
                        return
                    }

                    self.foodItems = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: FoodItem.self)
                    } ?? []

                    print("✅ Hittade \(self.foodItems.count) varor för kiosk \(kiosk.name)")
                }
            }
    }

    func handleTap(on item: FoodItem, cartItems: inout [FoodItem]) {
        pressedItemId = item.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pressedItemId = nil
        }

        if item.isAvailable {
            cartItems.append(item)
            print("🛒 Tillagd i kundvagn: \(item.name)")
        } else {
            print("❌ \(item.name) är slut")
        }
    }
}
