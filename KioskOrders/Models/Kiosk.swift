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

    // 🔹 Säker init som ger defaultvärden om något saknas i Firestore
    init(
        id: String? = nil,
        name: String = "Okänd kiosk",
        description: String = "",
        category: String = "misc",
        isActive: Bool = true,
        waitTime: Int = 5
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.isActive = isActive
        self.waitTime = waitTime
    }
}
