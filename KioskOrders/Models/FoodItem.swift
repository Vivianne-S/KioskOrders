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
    let name: String
    let price: Double
    let category: String
    let availableAt: [String]
}
