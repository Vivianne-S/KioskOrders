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
    let description: String
    let price: Double
    let category: String
    let availableAt: [String]
    let isAvailable: Bool
    let preparationTime: Int
}
