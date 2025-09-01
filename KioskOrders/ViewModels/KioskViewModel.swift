//
//  KioskViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import Foundation
import FirebaseFirestore

class KioskViewModel: ObservableObject {
    @Published var kiosks: [Kiosk] = []
    // @Published var foodItems: [FoodItem] = [] ← TAGIT BORT (används inte)
    
    private let db = Firestore.firestore()
    
    func loadKiosks() {
        db.collection("kiosk").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Fel vid hämtning av kiosker: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.kiosks = documents.compactMap { doc in
                var kiosk: Kiosk?
                do {
                    kiosk = try doc.data(as: Kiosk.self)
                } catch {
                    print("❌ Kunde inte mappa kiosk: \(error)")
                }
                if let k = kiosk {
                    if k.id == nil {
                        kiosk?.id = doc.documentID
                    }
                }
                return kiosk
            }
            print("📦 Hittade \(self.kiosks.count) kiosker")
            for k in self.kiosks {
                print("📌 \(k.name) - \(k.id ?? "Ingen ID")")
            }
        }
    }
}
