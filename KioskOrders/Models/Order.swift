//
//  Order.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//

import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var kioskId: String
    var userId: String
    var items: [OrderItem]
    var status: String              // "pending", "approved", "ready"
    var pickupTime: Date?
    @ServerTimestamp var createdAt: Date?
}

struct OrderItem: Codable, Identifiable {
    var id: String { name }
    var name: String
    var quantity: Int
    var price: Double
    var preparationTime: Int
}
