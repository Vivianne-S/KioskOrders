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
}
