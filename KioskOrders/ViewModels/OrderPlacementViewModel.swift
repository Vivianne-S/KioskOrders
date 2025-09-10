//
//  OrderPlacementViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


@MainActor
class OrderPlacementViewModel: ObservableObject {
    private let db = Firestore.firestore()

    enum PlaceOrderResult {
        case success
        case failure(String)
    }

    func placeOrder(kioskId: String, items: [FoodItem]) async -> PlaceOrderResult {
        guard let user = Auth.auth().currentUser else {
            print("❌ Ingen användare inloggad")
            return .failure("Ingen användare inloggad.")
        }
        guard !kioskId.isEmpty else {
            print("❌ kioskId saknas när order skickas")
            return .failure("Saknar kioskId (välj kiosk innan du beställer).")
        }
        guard !items.isEmpty else {
            print("❌ Inga items i kundvagnen")
            return .failure("Kundvagnen är tom.")
        }

        let orderData: [String: Any] = [
            "kioskId": kioskId,
            "userId": user.uid,
            "status": "pending",
            "pickupTime": NSNull(),
            "createdAt": FieldValue.serverTimestamp(),
            "items": items.map { [
                "name": $0.name,
                "quantity": 1,
                "price": $0.price,
                "preparationTime": $0.preparationTime
            ]}
        ]

        print("📤 Lägger order: kioskId=\(kioskId), userId=\(user.uid), items=\(items.map{$0.name})")

        do {
            let ref = try await db.collection("orders").addDocument(data: orderData)
            print("✅ Order registrerad i Firestore! id=\(ref.documentID)")
            return .success
        } catch {
            let msg = (error as NSError).localizedDescription
            print("❌ Firestore fel vid addDocument: \(msg)")
            return .failure(msg)
        }
    }
}
