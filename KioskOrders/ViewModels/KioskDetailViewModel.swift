//
//  KioskDetailViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//


import Foundation
import FirebaseFirestore

@MainActor
class KioskDetailViewModel: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var pressedItemId: String?

    private let db = Firestore.firestore()

    func fetchFoodItems(for kioskId: String) {
        isLoading = true
        errorMessage = nil

        db.collection("fooditems")
            .whereField("availableAt", arrayContains: kioskId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Firestore error: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.foodItems = []
                    return
                }

                self.foodItems = documents.compactMap { try? $0.data(as: FoodItem.self) }
            }
    }

    func handleTap(on item: FoodItem, cartItems: inout [FoodItem]) {
        guard item.isAvailable else { return }
        pressedItemId = item.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pressedItemId = nil
        }
        cartItems.append(item)
        print("🍭 Added \(item.name) to cart")
    }
}
