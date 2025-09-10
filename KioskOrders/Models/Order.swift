//
//  Order.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//
import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var kioskId: String
    var userId: String
    var items: [OrderItem]
    var status: String              // "pending", "approved", "ready", "confirmed"
    var pickupTime: Date?
    var confirmationNumber: Int?
    @ServerTimestamp var createdAt: Date?

    // 🔑 Gör Order Equatable baserat på id
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
}

struct OrderItem: Codable, Identifiable {
    var id: String { name }
    var name: String
    var quantity: Int
    var price: Double
    var preparationTime: Int
}
