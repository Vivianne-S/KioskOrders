//
//  FoodItem.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import Foundation
import FirebaseFirestore

struct FoodItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String? = ""   // 👈 gör optional med default
    var price: Double
    var category: String? = "Snacks" // 👈 gör optional med default
    var availableAt: [String]
    var isAvailable: Bool
    var preparationTime: Int
}
