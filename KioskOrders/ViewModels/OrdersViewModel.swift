
//
//  OrdersViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    deinit { listener?.remove() }
    
    // 🔎 Lyssna på ordrar för en kiosk
    func listenForOrders(kioskId: String) {
        listener?.remove()
        let uid = Auth.auth().currentUser?.uid ?? "-"
        print("👂 Startar orders-lyssnare kioskId=\(kioskId)  uid=\(uid)")
        
        listener = db.collection("orders")
            .whereField("kioskId", isEqualTo: kioskId)
            .addSnapshotListener { [weak self] snap, err in
                guard let self = self else { return }
                if let err = err {
                    print("❌ Snapshot error: \(err.localizedDescription)")
                    self.orders = []
                    return
                }
                
                let docs = snap?.documents ?? []
                print("📥 Snapshot \(docs.count) dokument")
                for d in docs {
                    let kid = d.get("kioskId") ?? "-"
                    let st  = d.get("status")  ?? "-"
                    print("• \(d.documentID)  kioskId=\(kid)  status=\(st)")
                }
                
                self.orders = docs.compactMap { try? $0.data(as: Order.self) }
                print("✅ Decodade \(self.orders.count) ordrar")
            }
        
    }
    
    // ✅ Godkänn order
    func approveOrder(orderId: String, pickupTime: Date) {
        db.collection("orders").document(orderId).updateData([
            "status": "approved",
            "pickupTime": Timestamp(date: pickupTime)
        ]) { err in
            if let err = err {
                print("❌ Approve error: \(err.localizedDescription)")
            } else {
                print("✅ Order \(orderId) godkänd")
            }
        }
    }
    
    // ✅ Markera order som redo
    func markOrderAsReady(orderId: String, readyTime: Date, completion: @escaping (Bool) -> Void) {
        db.collection("orders").document(orderId).updateData([
            "status": "ready",
            "pickupTime": Timestamp(date: readyTime)
        ]) { error in
            if let error = error {
                print("❌ Error marking order as ready: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Order \(orderId) markerad som redo")
                completion(true)
            }
        }
    }
    
    // ✅ Bekräfta order med tid + nummer
    func confirmOrder(orderId: String, pickupTime: Date, completion: @escaping (Bool) -> Void) {
        let confirmationNumber = Int.random(in: 1000...9999) // enkel slumpad kod
        
        db.collection("orders").document(orderId).updateData([
            "status": "confirmed",
            "pickupTime": Timestamp(date: pickupTime),
            "confirmationNumber": confirmationNumber
        ]) { error in
            if let error = error {
                print("❌ Error confirming order: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Order \(orderId) bekräftad med nummer \(confirmationNumber)")
                completion(true)
            }
        }
    }
    // Bekräfta att order är upphämtad
    func markOrderAsPickedUp(orderId: String, completion: @escaping (Bool) -> Void) {
        db.collection("orders").document(orderId).updateData([
            "status": "pickedUp"
        ]) { error in
            if let error = error {
                print("❌ Error marking order as picked up: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Order \(orderId) markerad som upphämtad")
                completion(true)
            }
        }
    }
    
}
