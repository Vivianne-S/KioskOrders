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

    /// Laddar alla kiosker från Firestore
    func loadKiosks() {
        listener?.remove() // ta bort ev. gammal lyssnare

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

                    // 👇 Säkerställ alltid att id sätts från dokumentets ID
                    kiosk?.id = doc.documentID

                    if let k = kiosk {
                        print("📍 Kiosk hittad: \(k.name) (id=\(k.id ?? "nil"))")
                    }
                } catch {
                    print("❌ Kunde inte mappa kiosk: \(error)")
                }
                return kiosk
            }

            print("📦 Totalt hittade \(self.kiosks.count) kiosker")
        }
    }
}
