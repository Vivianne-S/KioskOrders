//
//  KioskViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import Foundation
import FirebaseFirestore

@MainActor
class KioskViewModel: ObservableObject {
    @Published var kiosks: [Kiosk] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func loadKiosks() {
        listener?.remove()
        listener = db.collection("kiosk").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ Fel vid hämtning av kiosker: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.kiosks = documents.compactMap { doc in
                var kiosk: Kiosk?
                do {
                    kiosk = try doc.data(as: Kiosk.self)
                    if kiosk?.id == nil {
                        kiosk?.id = doc.documentID
                    }
                } catch {
                    print("❌ Kunde inte mappa kiosk: \(error)")
                }
                return kiosk
            }
            print("📦 Hittade \(self.kiosks.count) kiosker")
        }
    }
}
