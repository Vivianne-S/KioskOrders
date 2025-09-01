//
//  FirebaseService.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import Foundation
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    func fetchKiosks() async throws -> [Kiosk] {
        let snapshot = try await db.collection("kiosks").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Kiosk.self)
        }
    }
}