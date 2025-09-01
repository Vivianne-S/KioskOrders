//
//  Kiosk.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import Foundation
import FirebaseFirestore

struct Kiosk: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let category: String
    let isActive: Bool
    let waitTime: Int
    
    init(id: String? = nil, name: String, description: String, category: String, isActive: Bool, waitTime: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.isActive = isActive
        self.waitTime = waitTime
    }
}
